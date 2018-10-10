//
//  ViewController.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/30/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps


//MARK: - Mocked data -
class ViewController: UIViewController {
    
    //MARK: - properties -
    
    
    @IBOutlet weak var progressBar: UIProgressView! {
        didSet {
            progressBar.isHidden = true
        }
    }
    @IBOutlet weak var rangebutton: UIBarButtonItem!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 44
        }
    }
    @IBOutlet weak var dateRangeStackView: UIStackView! {
        didSet {
            dateRangeStackView.isHidden = true //Hide stackView
        }
    }
    @IBOutlet weak var minSliderLabel: UILabel! {
        didSet {
            minSliderLabel.textColor = .white
            minSliderLabel.textAlignment = .center
            minSliderLabel.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var maxSliderLabel: UILabel! {
        didSet {
            maxSliderLabel.textColor = .white
            maxSliderLabel.textAlignment = .center
            maxSliderLabel.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var minSlider: UISlider! {
        didSet {
            minSlider.minimumTrackTintColor = .red
            minSlider.maximumTrackTintColor = .green
            minSlider.value = 0.0
            minSlider.minimumValue = 0.0
        }
    }
    @IBOutlet weak var maxSlider: UISlider! {
        didSet {
            maxSlider.minimumTrackTintColor = .green
            maxSlider.maximumTrackTintColor = .red
            maxSlider.value = 0.0
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            distanceLabel.textColor = UIColor.white
            distanceLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let disposeBag = DisposeBag() //disposeBag for Disposables
    let deviceManager = DeviceManager()
    let mapManager = MapManager.sharedInstance
    let newCoordinates = PublishSubject<(CoordinateProtocol, Int)>()
    var selectedRow: Int?
    let mock = MockedDevices()
    var trackCoordinateObservable = PublishSubject<CoordinateProtocol>()
    
    
    //MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager.createMapFor(mapView) //Create map on UIView (mapView property)
        mapView.bringSubviewToFront(dateRangeStackView) //Bring stackView to front
        mapView.bringSubviewToFront(progressBar)
        let textAttibutes = [NSAttributedString.Key.foregroundColor: navigationController!.navigationBar.tintColor!]
        navigationController?.navigationBar.titleTextAttributes = textAttibutes
        //Modify tableView height depending on the number of devices connected
        deviceListObservable()
        
        //Center device on map
        centerDeviceOnMapObservable()
        
        //Track slider value changes
        trackSliderChangesObservable()
        
        //Add Mock Devices
        deviceManager.addDevice(mock.mock1)
        deviceManager.addDevice(mock.mock2)
        deviceManager.addDevice(mock.mock1)
        deviceManager.addDevice(mock.mock2)
        deviceManager.addDevice(mock.mock1)
        
    }
    
    func showProgress(_ progress: Double) {
       // print("Progress: \(progress)")
        self.progressBar.progress = Float(progress / 100)
    }
    
    ///Modify tableView height depending on the number of devices connected
    func deviceListObservable() {
        let maxHeight = 4 * tableView.estimatedRowHeight
        deviceManager.devices.asObservable().subscribe(onNext: { device in
            self.tableViewHeight.constant = min(CGFloat(device.count) * self.tableView.estimatedRowHeight, maxHeight)
        }).disposed(by: disposeBag)
    }
    
    func trackDeviceObservable() {
        deviceManager.devices.value[selectedRow!].coordinates
            .asObservable()
            .subscribe(onNext: { coord in
                self.navigationItem.title = "Tracking \(self.deviceManager.devices.value[self.selectedRow!].name)"
                self.mapManager.trackDevice(self.deviceManager.devices.value[self.selectedRow!])
                self.tableView.reloadRows(at: [IndexPath(row: self.selectedRow!, section: 0)], with: .automatic)
            }, onError: { error in
                AlertManager.showAlertWith(error.localizedDescription, inViewController: self)
            }, onCompleted: {
                self.navigationItem.title = ""
                print("Completed live track")
            }) {
                print("Disposed live track")
        }.disposed(by: disposeBag)
        
    }
    
    ///Center device on map
    func centerDeviceOnMapObservable() {
        trackCoordinateObservable.subscribe(onNext: { coord in
            self.mapManager.centerMapOnLocation(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
            self.trackDeviceObservable()
        }).disposed(by: disposeBag)
    }
    
    //Reset slider values when switching between devices
    func resetSliders() {
        guard let selectedRow = selectedRow else {return}
        minSlider.maximumValue = maxSlider.value
        maxSlider.minimumValue = minSlider.value
        maxSlider.maximumValue = Float(deviceManager.devices.value[selectedRow].coordinates.value.count - 1)
    }
    
    //Toggle isHidden state of UI elements and Range button title
    fileprivate func toggleUIElements() {
        progressBar.progress = 0.0
        self.dateRangeStackView.isHidden = !self.dateRangeStackView.isHidden
        self.mapManager.mapView.settings.myLocationButton = !self.mapManager.mapView.settings.myLocationButton
        self.rangebutton.title = self.dateRangeStackView.isHidden ? "Range" : "Finish"
        navigationItem.title = self.dateRangeStackView.isHidden ? "" : "Syncing data"
        self.tableView.reloadData() //MARK: TEMP conveniance
    }
    
    @IBAction func rangeButtonAction(_ sender: Any) {
        toggleUIElements()
    }
    
    func updateLabelsWith(_ minDate: String, end maxDate: String) {
        minSliderLabel.text = minDate
        maxSliderLabel.text = maxDate
    }
    
    ///Track slider value changes
    func trackSliderChangesObservable() {
        Observable.combineLatest(minSlider.rx.value, maxSlider.rx.value) { (min, max) in
            guard let selectedRow = self.selectedRow else {return}
            self.minSlider.maximumValue = self.maxSlider.value
            self.maxSlider.minimumValue = self.minSlider.value
            self.maxSlider.maximumValue = Float(self.deviceManager.devices.value[selectedRow].coordinates.value.count - 1)
            let min = Int(min.rounded())
            let max = Int(max.rounded())
            self.updateLabelsWith(self.deviceManager.devices.value[selectedRow].coordinates.value[min].timestamp.stringOfDate, end: self.deviceManager.devices.value[selectedRow].coordinates.value[max].timestamp.stringOfDate)
            self.trackSliderChanges(minValue: min, maxValue: max)
            }.subscribe()
            .disposed(by: disposeBag)
    }
    
    func trackSliderChanges(minValue min: Int, maxValue max: Int) {
        guard let selectedRow = selectedRow else {return}
        var tempArray = [CoordinateProtocol]()
        let observable = deviceManager.getDateRangeFor(deviceManager.devices.value[selectedRow], startDate: deviceManager.devices.value[selectedRow].coordinates.value[min].timestamp, endDate: deviceManager.devices.value[selectedRow].coordinates.value[max].timestamp)
        observable.0
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { coord in
                self.progressBar.isHidden = false
                let progress = Double(tempArray.count) / Double(observable.1) * 100
                self.showProgress(progress)
                tempArray.append(coord)
            }, onError: { error in
                AlertManager.showAlertWith(error.localizedDescription, inViewController: self)
            }, onCompleted: {
               
                self.mapManager.drawRangeFor(tempArray)
                self.progressBar.isHidden = true
                print("Completed")
            }) {
                print("Disposed")
            }.disposed(by: disposeBag)
    }
    
    @IBAction func syncAction(_ sender: Any) {
        guard let selectedRow = selectedRow else {return}
        let observable = deviceManager.syncDataFor(deviceManager.devices.value[selectedRow])
        var tempArray = [CoordinateProtocol]()
        
        observable.0
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { element in
                self.navigationItem.title = "Syncing data"
                self.progressBar.isHidden = false
                print(element, observable.1)
                tempArray.append(element)
                let progress = Double(tempArray.count) / Double(observable.1) * 100
                self.showProgress(progress)
                self.mapManager.drawSyncPolylinesFor(tempArray)
            }, onError: {error in
                print("Error: \(error)")
                AlertManager.showAlertWith(error.localizedDescription, inViewController: self)
            }, onCompleted: {
                self.navigationItem.title = ""
                self.progressBar.isHidden = true
                print("Completed")
            }, onDisposed: {
                print("Disposed")
            }).disposed(by: disposeBag)
    }
    
    //No selected row alert
    func noRowSelectedAlert() {
        let alert = UIAlertController(title: "Warning", message: "You need to select a device from the list first", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func delayFor(_ interval: TimeInterval, completion: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
        }
    }
}
//MARK: Extensions in Extensions folder

