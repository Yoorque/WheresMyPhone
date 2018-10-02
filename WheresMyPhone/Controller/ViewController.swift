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
    
    let disposeBag = DisposeBag() //disposeBag for Disposables
    let deviceManager = DeviceManager()
    let mapManager = MapManager.sharedInstance

    //MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager.createMapFor(mapView) //Create map on UIView (mapView property)
        mapView.bringSubviewToFront(dateRangeStackView) //Bring stackView to front
        dateRangeStackView.isHidden = true //Hide stackView
        
        //Add Mock Devices
        deviceManager.addDevice(MockedDevices.mock1)
        deviceManager.addDevice(MockedDevices.mock2)
    }
    @IBAction func rangeButtonAction(_ sender: Any) {
        let device = deviceManager.devices.value[tableView.indexPathForSelectedRow!.row]
        deviceManager.getDateRangeFor(device, startDate: device.coordinates.first!.timestamp, endDate: device.coordinates.last!.timestamp)
        
    }
    
    @IBAction func syncAction(_ sender: Any) {
        let device = deviceManager.devices.value[tableView.indexPathForSelectedRow!.row]
        deviceManager.syncDataFor(device)
        
    }
}
//MARK: Extensions in Extensions folder
