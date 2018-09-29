//
//  ViewController.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/30/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

//MARK: - Mocked data -
class ViewController: UIViewController {
    
    //MARK: - properties -
    var viewModel = DeviceViewModel(devices: Variable([]))
    let publishCoordSubject = PublishSubject<CLLocation>() //Publishing new coordinate data
    let disposeBag = DisposeBag() //disposeBag for Disposables
    let drawing = Drawing() //used for drawing polylines
    let locationManager = CLLocationManager()
    var previouslySelected = IndexPath() //Keeps track if pressed row in tableView is already selected
    var mockData = MockData()
    var binder = Variable<[Int]>([])
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 44
        }
    }
    @IBOutlet weak var dateRangeStackView: UIStackView!
    
    @IBOutlet weak var minSliderLabel: UILabel! {
        didSet {
            minSliderLabel.textColor = .white
            minSliderLabel.textAlignment = .center
            minSliderLabel.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        }
    }
    @IBOutlet weak var maxSliderLabel: UILabel! {
        didSet {
            maxSliderLabel.textColor = .white
            maxSliderLabel.textAlignment = .center
            maxSliderLabel.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        }
    }
    @IBOutlet weak var minSlider: UISlider! {
        didSet {
            minSlider.minimumTrackTintColor = .red
            minSlider.maximumTrackTintColor = .green
            minSlider.minimumValue = 0.0
        }
    }
    @IBOutlet weak var maxSlider: UISlider! {
        didSet {
            maxSlider.minimumTrackTintColor = .green
            maxSlider.maximumTrackTintColor = .red
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.backgroundColor = .lightGray
            distanceLabel.textColor = UIColor.white
            distanceLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    //MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerSetup() //Setup locationManager
        mapSetup() //Setup settings for mapView
        setupNavigationBar() //Setup navigationBar buttons
        setupSliders() //Setup slider views
        
        //Subscribing to events for count property change of viewModel.devices array and
        //modifying UI according to the result
        viewModel.devices.asObservable().subscribe(onNext: { (devices) in
            devices.count == 0 ? self.removeTableView() : self.displayTableView()
        }).disposed(by: disposeBag)
        
        //Combine values from both sliders and update range lines
        Observable.combineLatest(minSlider.rx.value, maxSlider.rx.value) {[weak self] (min, max) in
            self?.updateRangeLines(with: min, and: max)
            }.subscribe().disposed(by: disposeBag)
        
        //Subscribe to onNext events for new locations
        publishCoordSubject.subscribe(onNext: { location in
            guard self.viewModel.devices.value.count != 0 else {return}
            guard let row = self.tableView.indexPathForSelectedRow?.row else {return}
            
            let passedInLocation = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: location.timestamp, accuracy: location.horizontalAccuracy)
            
            self.viewModel.devices.value[row].coordinates.append(passedInLocation)
            self.drawing.drawPolylinesOn(self.mapView, forDevice: self.viewModel.devices.value[row])
        }).disposed(by: disposeBag)
        
        mockData.mockedDataWithTimer(for: self, and: tableView) //Timer for displaying mocked CLLocations over time using publishCoordSubject
        
    }
    
    
    ///Used to select values that represent the starting and ending point of a range
    func updateRangeLines(with start: Float, and end: Float) {
        //Check if there is a row selected
        if let row = self.tableView.indexPathForSelectedRow?.row {
    
            self.minSlider.value = start
            self.maxSlider.value = end
            
            //Limit min and max values of sliders according to the values of passed in value object
            self.minSlider.minimumValue = 0.0
            self.maxSlider.maximumValue = Float(self.viewModel.devices.value[row].coordinates.count - 1)
            self.maxSlider.minimumValue = self.minSlider.value
            self.minSlider.maximumValue = self.maxSlider.value
            
            //Select the timestamp value from an array of coordinates, according to the index passed in as value of the passed in element
            let startCoords = CLLocationCoordinate2D(latitude: self.viewModel.devices.value[row].coordinates[Int(start.rounded())].latitude, longitude: self.viewModel.devices.value[row].coordinates[Int(start.rounded())].longitude)
            let endCoords = CLLocationCoordinate2D(latitude: self.viewModel.devices.value[row].coordinates[Int(end.rounded())].latitude, longitude: self.viewModel.devices.value[row].coordinates[Int(end.rounded())].longitude)
            
            let startLocation = CLLocation(coordinate: startCoords, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: self.viewModel.devices.value[row].coordinates[Int(self.minSlider.value.rounded())].timestamp)
            let endLocation = CLLocation(coordinate: endCoords, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: self.viewModel.devices.value[row].coordinates[Int(self.maxSlider.value.rounded())].timestamp)
            
            //Calculate distance between two selected coordinates
            self.distanceLabel.text = self.getDistanceBetweenLocation(startLocation, and: endLocation)
            
            //Draw selected range
            self.drawing.drawDateRangePolylinesFor(self.viewModel.devices.value[row], mapView: self.mapView, between: startLocation, and: endLocation)
            
            //Use converted timestamp to display in the appropriate label
            self.minSliderLabel.text = startLocation.timestamp.stringOfDate
            self.maxSliderLabel.text = endLocation.timestamp.stringOfDate
        }

    }
    
    
    ///Measures distance between two locations
    func getDistanceBetweenLocation(_ startLocation: CLLocation, and endLocation: CLLocation) -> String {
        let distance = startLocation.distance(from: endLocation)
        return distance.toKm
    }
    
    //MARK: - Helper methods -
    ///Hides the tableView with slide-down animation and alpha decrease to 0.0
    fileprivate func removeTableView() {
        self.mapView.clear()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.tableView.alpha = 0
                self.tableViewHeight.constant = 0
            })
        }
    }
    
    ///Shows the tableView with slide-up animation and alpha increase 1.0
    fileprivate func displayTableView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.tableView.alpha = 1
                self.tableViewHeight.constant = CGFloat(self.viewModel.devices.value.count * Int(self.tableView.estimatedRowHeight))
            })
        }
    }
    
    ///Add left and right navigationBar buttons for removing and adding new Devices
    fileprivate func setupNavigationBar() {
        view.backgroundColor = UIColor.lightText //Set view background color
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Disconnect", style: .done, target: self, action: #selector(disconnectDevice))
        let connectButton = UIBarButtonItem(title: "Connect", style: .done, target: self, action: #selector(connectDevice))
        let dateButton = UIBarButtonItem(title: "Select Range", style: .done, target: self, action: #selector(dateRangeNavButton))
        self.navigationItem.rightBarButtonItems = [connectButton, dateButton]
    }
    
    ///Setup Location Manager
    fileprivate func locationManagerSetup() {
        locationManager.delegate = self
        locationManager.showsBackgroundLocationIndicator = true //Enables background tracking and indicator
        locationManager.allowsBackgroundLocationUpdates = true //Enables background tracking and indicator
        locationManager.requestAlwaysAuthorization() //Request authorisation from the user on initial app run
        locationManager.requestWhenInUseAuthorization() //Request authorisation from the user on initial app run
        locationManager.startUpdatingLocation()
        
        //Center map on current user location if location available
        if let currentLocation = locationManager.location {
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), zoom: 10)
            mapView.camera = camera
        }
    }
    
    ///Toggles hidden and non-hidden state of sliders and labels related to date range and changes title of the button
    ///Also, displays a warning if no device was selected before pressing the dates button
    @objc func dateRangeNavButton() {
        if tableView.indexPathForSelectedRow != nil {
            if dateRangeStackView.isHidden {
                mapView.settings.myLocationButton = false
                dateRangeStackView.isHidden = false
                navigationItem.rightBarButtonItems![1].title = "Finish"
                minSliderLabel.text = "Start date"
                maxSliderLabel.text = "End date"
            } else {
                mapView.settings.myLocationButton = true
                dateRangeStackView.isHidden = true
                navigationItem.rightBarButtonItems![1].title = "Select Range"
                drawing.clearRangePolylines()
            }
        } else {
            let alert = UIAlertController(title: "Date Selection", message: "Please select a device and try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    ///Setup slider position in the superview
     func setupSliders() {
        dateRangeStackView.frame = CGRect(x: 10, y: mapView.frame.maxY - 120, width: mapView.frame.size.width - 20, height: 100)
        minSlider.value = 0
        maxSlider.value = 0
        mapView.bringSubviewToFront(dateRangeStackView)
        dateRangeStackView.isHidden = true
        navigationItem.rightBarButtonItems![1].title = "Select Range"
    }
    
    ///Setup map
    fileprivate func mapSetup() {
        mapView.delegate = self //Assign mapView delegate to 'self'
        mapView.settings.compassButton = true //Displays compas on the map when map heading is changed
        mapView.settings.myLocationButton = true //Displays round myLocation button
        mapView.isMyLocationEnabled = true //Enables user location
    }
    
    ///Connect dvices
    @objc func connectDevice() {
        //New discovered devices will be connected and added to viewModel devices array, instead of MockDevices
        for device in mockData.devices { //Add mock devices from devices array
            viewModel.addDevice(device)
            tableView.reloadData()
        }
    }
    
    ///Remove Device from the array of devices
    @objc func disconnectDevice() {
        guard viewModel.devices.value.count != 0 else {return} //Check the count of devices, if 0, return
        //viewModel.removeLastDevice() // Remove last device from devices array
        guard let row = tableView.indexPathForSelectedRow?.row else {return} //If device row is selected, extract the row Int
        drawing.removePolylinesFor(viewModel.devices.value[row].name)
        drawing.clearRangePolylines()
        setupSliders()
        viewModel.removeDevice(named: viewModel.devices.value[row].name) //Remove specific Device.
    }
}
//MARK: Extensions in Extensions folder
