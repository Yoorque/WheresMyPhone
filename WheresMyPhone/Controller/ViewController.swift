//
//  ViewController.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/30/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps

//MARK: - Mocked data -
class ViewController: UIViewController {
    
    //MARK: - properties -
    
    
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
            distanceLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            distanceLabel.textColor = UIColor.white
            distanceLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let disposeBag = DisposeBag() //disposeBag for Disposables
    let deviceManager = DeviceManager()
    let mapManager = MapManager.sharedInstance

    //MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager.createMapFor(mapView) //Create map on UIView (mapView property)
        mapView.bringSubviewToFront(dateRangeStackView) //Bring stackView to front
        deviceManager.devices.asObservable().subscribe(onNext: {device in
            self.tableViewHeight.constant = self.tableView.estimatedRowHeight * CGFloat(device.count)
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        //Add Mock Devices
        deviceManager.addDevice(MockedDevices.mock1)
        deviceManager.addDevice(MockedDevices.mock2)
    }
    
    fileprivate func toggleUIElements() {
        self.dateRangeStackView.isHidden = !self.dateRangeStackView.isHidden
        self.mapManager.mapView.settings.myLocationButton = !self.mapManager.mapView.settings.myLocationButton
    }
    
    @IBAction func rangeButtonAction(_ sender: Any) {
        guard let row = tableView.indexPathForSelectedRow?.row else {
            self.noRowSelectedAlert()
            return
        }
        toggleUIElements()
        let device = deviceManager.devices.value[row]
        deviceManager.getDateRangeFor(device, startDate: device.coordinates.first!.timestamp, endDate: device.coordinates.last!.timestamp)
    }
    
    @IBAction func syncAction(_ sender: Any) {
        guard let row = tableView.indexPathForSelectedRow?.row else {
            self.noRowSelectedAlert()
            return
        }
        let device = deviceManager.devices.value[row]
        deviceManager.syncDataFor(device)
    }
    
    func noRowSelectedAlert() {
        let alert = UIAlertController(title: "Warning", message: "You need to select a device from the list first", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
//MARK: Extensions in Extensions folder
