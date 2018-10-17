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
    ///Row selected in tableView(:didSelectRowAt:).
    ///- Note: If row is not selected, returns `nil`.
    var selectedRow: Int?
    var trackCoordinatePublishSubject = PublishSubject<CoordinateProtocol>()
    var previouslySelected: IndexPath!
    var viewModel = ViewModel()
    
    let errors = PublishRelay<Error>()
    
    
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
        
//        //Track slider value changes
//        trackSliderChangesObservable()
        
        //Initialize PublishSubject for centering map on row selection
       // centerDeviceOnMapPublish()
        
        errors
            .observeOn(MainScheduler.instance)
            .map({error in
                return WMPError.deviceNotSelected // Implement switching through different errors
            })
            .subscribe(onNext: { error in
                AlertManager.errorAlert(withError: error, self)
            })
            .disposed(by: disposeBag)
    }
    
    func showProgress(_ progress: Double) {
       // print("Progress: \(progress)")
        self.progressBar.progress = Float(progress / 100)
    }
    
    ///Observes changes in list of connected devices and modifies tableView height depending on the number of connected devices.
    ///- Note: Called from `viewDidLoad()`.
    func deviceListObservable() {
        let maxHeight = 4 * tableView.estimatedRowHeight

        viewModel.devices
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { device in
                print("Device: \(device)")
                DispatchQueue.main.async {
                    self.tableViewHeight.constant = min(CGFloat(device.count) * self.tableView.estimatedRowHeight, maxHeight)
                }
            }, onError: {error in
                print("error: \(error)")
            }, onCompleted: {
                print("Completed device list obs")
            }, onDisposed: {
                print("Disposed device list obs")
            }).disposed(by: disposeBag)
    }

    ///Observes changes in selected device's coordinate array and tracks device on screen.
    ///- Note: Called from `centerDeviceOnMapObservable()` method when device is selected.
    func trackDeviceObservable() {
//        guard let selectedRow = selectedRow else {
//            AlertManager.errorAlert(withError: WMPError.deviceNotSelected, self)
//            return
//        }
//        viewModel.devices.value[selectedRow].coordinates
//            .asObservable()
//            .subscribe(onNext: { coord in
//                self.navigationItem.title = "Tracking \(self.viewModel.devices.value[self.selectedRow!].name)"
//                self.mapManager.trackDevice(self.viewModel.devices.value[selectedRow])
//                self.tableView.reloadRows(at: [IndexPath(row: self.selectedRow!, section: 0)], with: .automatic)
//            }, onError: { error in
//                AlertManager.errorAlert(withError: WMPError.noNewCoordinates, self)
//            }, onCompleted: {
//                self.navigationItem.title = ""
//                print("Completed live track")
//            }) {
//                print("Disposed live track")
//        }.disposed(by: disposeBag)
//
    }

    ///Observes selection of the device from the `tableView` and centers map on the selected device's last coordinate upon receipt of `onNext()` event from `trackCoordinatePublishSubject`.
    ///- Note: Called from `viewDidLoad()`. `onNext` event is sent from `tableView(:didSelectRowAt:)`.
    func centerDeviceOnMapPublish() {
//        trackCoordinatePublishSubject.subscribe(onNext: { coord in
//            self.resetSliders()
//            self.mapManager.centerMapOnLocation(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
//
//            //Track device Observable
//           // self.trackDeviceObservable()
//        }).disposed(by: disposeBag)
    }
    
    ///Reset slider values when switching between devices.
    func resetSliders() {
//        guard let selectedRow = selectedRow else {
//            AlertManager.errorAlert(withError: WMPError.deviceNotSelected, self)
//            return
//        }
//        minSlider.maximumValue = maxSlider.value
//        maxSlider.minimumValue = minSlider.value
//        maxSlider.maximumValue = Float(viewModel.devices.value[selectedRow].coordinates.value.count - 1)
//        maxSlider.value = 0.0
//        minSlider.value = 0.0
    }

    
    @IBAction func scanButton(_ sender: Any) {
        //Start scanning for peripherals
        let observable = deviceManager.scanForPeripherals()
        
        let devices = observable
           
//            .map({ (vvv) -> (name: String, uuid: String)  in
//                print(vvv)
//                return vvv
//            })
//            .do(onNext: {
//                print($0)
//            })
//            .share(replay: 1)
        
        devices
            .asDriver(onErrorJustReturn: ("", ""))
            .drive(onNext: {
                self.viewModel.addDevice($0)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        devices
            .subscribe( onError: { (error) in
                self.errors.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func rangeButtonAction(_ sender: Any) {
        toggleUIElements()
    }
    
    ///Toggle UI elements, Range button title and navigationItem title.
    fileprivate func toggleUIElements() {
        progressBar.progress = 0.0
        self.dateRangeStackView.isHidden = !self.dateRangeStackView.isHidden
        MapManager.sharedInstance.mapView.settings.myLocationButton = !self.mapManager.mapView.settings.myLocationButton
        self.rangebutton.title = self.dateRangeStackView.isHidden ? "Range" : "Finish"
        navigationItem.title = self.dateRangeStackView.isHidden ? "" : "Syncing data"
        MapManager.sharedInstance.removeRangePolylines()
        self.tableView.reloadData() //MARK: TEMP conveniance
    }
    
    ///Updates slider labels with current selected dates.
    ///- Parameter minDate: Starting date.
    ///- Parameter maxDate: Ending date.
    func updateLabelsWith(_ minDate: String, end maxDate: String) {
        minSliderLabel.text = minDate
        maxSliderLabel.text = maxDate
    }
    
    ///Track slider value changes and calls `updateLabelsWith(minDate:maxDate:)` method.
    func trackSliderChangesObservable() {
//        Observable.combineLatest(minSlider.rx.value, maxSlider.rx.value) { (min, max) in
//            guard let selectedRow = self.selectedRow else {return}
//            self.minSlider.maximumValue = self.maxSlider.value
//            self.maxSlider.minimumValue = self.minSlider.value
//            self.maxSlider.maximumValue = Float(self.viewModel.devices.value[selectedRow].coordinates.value.count - 1)
//            let min = Int(min.rounded())
//            let max = Int(max.rounded())
//            self.updateLabelsWith(self.viewModel.devices.value[selectedRow].coordinates.value[min].timestamp.stringOfDate, end: self.viewModel.devices.value[selectedRow].coordinates.value[max].timestamp.stringOfDate)
//            //self.trackSliderChanges(minValue: min, maxValue: max)
//            }.subscribe()
//            .disposed(by: disposeBag)
//
    }
    
    ///Tracks changes and subscribes to `Observable` received as a return value of `getDateRangeFor(startDate:endDate:)` method in `deviceManager` class.
    ///- Note: Called from `trackSliderChangesObservable()` method when slider values change.
    func trackSliderChanges(minValue min: Int, maxValue max: Int) {
//        guard let selectedRow = selectedRow else {
//            AlertManager.noRowSelectedAlert(self)
//            return
//        }
//        var tempArray = [CoordinateProtocol]()
//        let observable = deviceManager.getDateRangeFor(viewModel.devices.value[selectedRow], startDate: viewModel.devices.value[selectedRow].coordinates.value[min].timestamp, endDate: viewModel.devices.value[selectedRow].coordinates.value[max].timestamp)
//        observable.0
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { coord in
//                self.progressBar.isHidden = false
//                let progress = Double(tempArray.count) / Double(observable.1) * 100
//                self.showProgress(progress)
//                tempArray.append(coord)
//            }, onError: { error in
//                AlertManager.showAlertWith(error.localizedDescription, inViewController: self)
//            }, onCompleted: {
//
//                MapManager.sharedInstance.drawRangeFor(tempArray)
//                self.progressBar.isHidden = true
//               // print("Completed")
//            }) {
//              //  print("Disposed")
//            }.disposed(by: disposeBag)
    }
    
    @IBAction func syncAction(_ sender: Any) {
////        guard let selectedRow = selectedRow else {
////            errors.accept(error)
////            return
////        }
//        let observable = deviceManager.syncDataFor(viewModel.devices.value[selectedRow!])
//        var tempArray = [CoordinateProtocol]()
//
//        observable.0
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { element in
//                self.navigationItem.title = "Syncing data"
//                self.progressBar.isHidden = false
//                //print(element, observable.1)
//                tempArray.append(element)
//                let progress = Double(tempArray.count) / Double(observable.1) * 100
//                self.showProgress(progress)
//                self.mapManager.drawSyncPolylinesFor(tempArray)
//            }, onError: {error in
//                //print("Error: \(error)")
//                errors.accept(error)
//            }, onCompleted: {
//                self.navigationItem.title = ""
//                self.progressBar.isHidden = true
//                //print("Completed")
//            }, onDisposed: {
//                //print("Disposed")
//            }).disposed(by: disposeBag)
    }
}

//MARK: - tableViewDelegate and tableViewDataSource -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.devices.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceCell
        let vm = viewModel.devices.value[indexPath.row]
        cell.nameLabel.text = vm.name
        cell.uuidLabel.text = vm.uuid
        return cell
    }
    
    
    //Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        if previouslySelected != indexPath {
            MapManager.sharedInstance.removeSyncPolylines()
            MapManager.sharedInstance.removeRangePolylines()
        }
        previouslySelected = indexPath
        
        deviceManager.connectTo(viewModel.devices.value[indexPath.row].name)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _,_,_ in
            self.selectedRow = 0
            self.viewModel.removeDevice(AtIndex: indexPath.row)
            self.tableView.reloadData()
        })
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}
