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

//MARK: - Mocked data -
class ViewController: UIViewController {
    
    //MARK: - properties -
    var viewModel = DeviceViewModel(devices: [])
    let publishDeviceCountSubject = PublishSubject<Int>() // reactive component for tracking viewModel.devices.count values
    let publishCoordSubject = PublishSubject<CLLocation>()
    let publishDateSliderSubject = PublishSubject<(Float,String)>()
    let disposeBag = DisposeBag() //disposeBag for Disposables
    let drawing = Drawing() //used for drawing polylines
    let locationManager = CLLocationManager()
    var previouslySelected = IndexPath()
    var mockData = MockData()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateRangeStackView: UIStackView!
    @IBOutlet weak var minSliderLabel: UILabel!
    @IBOutlet weak var maxSliderLabel: UILabel!
    @IBOutlet weak var minSlider: UISlider!
    @IBOutlet weak var maxSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerSetup() //setup locationManager
        mapSetup() //setup settings for mapView
        setupNavigationBar() //setup navigationBar buttons
        setupSliders() //setup slider views
        
        //subscribing to onNext events for count property of viewModel.devices array and
        //modifying UI according to the result
        publishDeviceCountSubject.subscribe(onNext: { count in
            
            if count == 0 { //if viewModel.devices.count is 0, tableView is hidden and mapView spans over the entire screen
                self.removeTableView()
                
            } else { //else, tableView is showing with the list of devices and mapView takes up it's position above tableView
                self.displayTableView()
            }
        }).disposed(by: disposeBag)
        
        publishDeviceCountSubject.onNext(viewModel.devices.count) //Initially checks count property of viewModel.devices array
        
        publishCoordSubject.subscribe(onNext: { location in //Subscribe to onNext events
            guard self.viewModel.devices.count != 0 else {return}
            guard let row = self.tableView.indexPathForSelectedRow?.row else {return}
            
            let passedInLocation = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: location.timestamp, accuracy: location.horizontalAccuracy)
            
            self.viewModel.devices[row].coordinates.append(passedInLocation)
            self.drawing.drawPolylinesOn(self.mapView, forDevice: self.viewModel.devices[row], withZoom: self.mapView.camera.zoom)
        }).disposed(by: disposeBag)
        
        publishDateSliderSubject.subscribe(onNext: { (value, slider) in
            //Check if there is a row selected
            if let row = self.tableView.indexPathForSelectedRow?.row {
                //limit min and max values of sliders according to the values of passed in value object
                self.minSlider.maximumValue = self.maxSlider.value
                self.maxSlider.minimumValue = self.minSlider.value
                self.maxSlider.maximumValue = Float(self.viewModel.devices[row].coordinates.count - 1)
                
                //check the passed in string from tuple passed in to determine which slider was moved
                if slider == "startDate" {
                    self.maxSlider.minimumValue = value
                } else if slider == "endDate" {
                    self.minSlider.maximumValue = value
                }
                
                //selct the timestamp value from an array of coordinates, according to the index passed in as value of the passed in element
                let minDate = self.viewModel.devices[row].coordinates[Int(self.minSlider.value)].timestamp
                let maxDate = self.viewModel.devices[row].coordinates[Int(self.maxSlider.value)].timestamp
                
                //draw selected range
                self.drawing.drawDateRangePolylinesFor(self.viewModel.devices[row], mapView: self.mapView, between: minDate, and: maxDate)
                
                //use converted timestamp to display in the appropriate label
                self.minSliderLabel.text = self.viewModel.devices[row].coordinates[Int(self.minSlider.value)].timestamp.formatDate()
                self.maxSliderLabel.text = self.viewModel.devices[row].coordinates[Int(self.maxSlider.value)].timestamp.formatDate()
            }
        }).disposed(by: disposeBag)
        
        mockData.mockedDataWithTimer(for: self, and: tableView) //Timer for displaying mocked CLLocations over time using publishCoordSubject
        
    }

    //publish onNext event as a tuple of current slider value and a hardcoded string to be able to recognize which slider fired the event
    @objc func didChangeStartDate(_ sender: Any) { //detects changes in maxSlider
        if let slider = sender as? UISlider {
            publishDateSliderSubject.onNext((slider.value, "startDate"))
        }
    }
    
    @objc func didChangeEndDate(_ sender: Any) { //detects changes in minSlider
        if let slider = sender as? UISlider {
            publishDateSliderSubject.onNext((slider.value, "endDate"))
        }
    }
    
    //MARK: - Helper methods -
    
    //Hides the tableView with slide-down animation and alpha decrease to 0.0
    fileprivate func removeTableView() {
        self.mapView.clear()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.tableView.alpha = 0
                self.mapView.frame.size.height = self.view.frame.size.height
                self.tableView.frame.origin.y = self.view.frame.maxY
            })
        }
    }
    
    //Shows the tableView with slide-up animation and alpha increase 1.0
    fileprivate func displayTableView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.tableView.alpha = 1
                let result = self.mapView.frame.intersection(self.tableView.frame)
                let resultView = UIView(frame: result)
                resultView.backgroundColor = .red
                self.mapView.frame.size.height = self.view.frame.size.height - self.tableView.frame.size.height
                self.tableView.frame.origin.y = self.view.frame.size.height - self.tableView.frame.size.height
            })
        }
    }
    
    fileprivate func setupNavigationBar() {
        view.backgroundColor = UIColor.lightText //set view background color
        
        //add left and right navigationBar buttons for removing and adding new Devices
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Disconnect", style: .done, target: self, action: #selector(disconnectDevice))
        let connectButton = UIBarButtonItem(title: "Connect", style: .done, target: self, action: #selector(connectDevice))
        let dateButton = UIBarButtonItem(title: "Select Range", style: .done, target: self, action: #selector(dateRangeNavButton))
        
        self.navigationItem.rightBarButtonItems = [connectButton, dateButton]
    }
    
    fileprivate func locationManagerSetup() {
        locationManager.delegate = self
        locationManager.showsBackgroundLocationIndicator = true //enables background tracking and indicator
        locationManager.allowsBackgroundLocationUpdates = true //enables background tracking and indicator
        locationManager.requestAlwaysAuthorization() //request authorisation from the user on initial app run
        locationManager.requestWhenInUseAuthorization() //request authorisation from the user on initial app run
        locationManager.startUpdatingLocation()
        
        //center map on current user location if location available
        if let currentLocation = locationManager.location {
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), zoom: 10)
            mapView.camera = camera
        }
    }
    
    //Toggles hidden and non-hidden state of sliders and labels related to date range and changes title of the button
    //Also, displays a warning if no device was selected before pressing the dates button
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
            let alert = UIAlertController(title: "Date Selection", message: "Please select the device and try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //setup slider position in the superview
     func setupSliders() {
        
        dateRangeStackView.frame = CGRect(x: 10, y: mapView.frame.maxY - 120, width: mapView.frame.size.width - 20, height: 100)
        self.minSlider.minimumValue = 0.0
        
        minSliderLabel.textColor = .white
        maxSliderLabel.textColor = .white
        
        minSliderLabel.textAlignment = .center
        maxSliderLabel.textAlignment = .center
        
        minSliderLabel.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        maxSliderLabel.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        
        minSlider.minimumTrackTintColor = .red
        minSlider.maximumTrackTintColor = .green
        
        maxSlider.maximumTrackTintColor = .red
        maxSlider.minimumTrackTintColor = .green
        
        minSlider.addTarget(self, action: #selector(didChangeStartDate), for: .valueChanged)
        maxSlider.addTarget(self, action: #selector(didChangeEndDate), for: .valueChanged)
        
        mapView.bringSubviewToFront(dateRangeStackView)
        dateRangeStackView.isHidden = true
        navigationItem.rightBarButtonItems![1].title = "Select Range"
    }
    
    fileprivate func mapSetup() {
        mapView.delegate = self //assign mapView delegate to 'self'
        mapView.settings.compassButton = true //displays compas on the map when map heading is changed
        mapView.settings.myLocationButton = true //displays round myLocation button
        mapView.isMyLocationEnabled = true //enables user location
    }
    
    @objc func connectDevice() {        
        for device in mockData.devices { //add mock devices from devices array
            if viewModel.addDevice(device) == true {
                publishDeviceCountSubject.onNext(viewModel.devices.count) //advertises onNext event once the 'viewModel.devices.count' changes
                tableView.reloadData()
            }
        }
    }
    
    //Remove Device from the array of devices
    @objc func disconnectDevice() {
        guard viewModel.devices.count != 0 else {return} //check the count of devices, if 0, return
        //viewModel.removeLastDevice() // remove last device from devices array
        guard let row = tableView.indexPathForSelectedRow?.row else {return} //if device row is selected, extract the row Int
        drawing.removePolylinesFor(viewModel.devices[row].name)
        viewModel.removeDevice(named: viewModel.devices[row].name) //remove specific Device.
        publishDeviceCountSubject.onNext(viewModel.devices.count) //advertise onNext event once the 'viewModel.devices.count' changes
        tableView.reloadData() //reload tableView
    }
}
//MARK: Extensions in Extensions folder




