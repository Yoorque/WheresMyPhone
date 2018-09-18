//
//  ViewController+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import GoogleMaps

//MARK: - tableViewDelegate and tableViewDataSource -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let device = viewModel.devices[indexPath.row]
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.uuid
        
        return cell
    }
    
    //Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if previouslySelected != indexPath {
            mapView.clear()
        }
        let selectedDevice = viewModel.devices[indexPath.row]
        
        CATransaction.setAnimationDuration(0.5)
        CATransaction.begin()
        mapView.animate(toZoom: 3)
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: selectedDevice.coordinates.last!.latitude, longitude: selectedDevice.coordinates.last!.longitude))
        CATransaction.commit()
        previouslySelected = indexPath
    }
}

//MARK: - LocationManagerDelegate -
extension ViewController: CLLocationManagerDelegate {
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
//        guard let location = locations.last else {return} //takes the last user location
//        guard viewModel.devices.count != 0 else {return}
//
//        if index > viewModel.devices.count - 1 {
//            index = viewModel.devices.count - 1
//        }
//        viewModel.devices[index].coordinates.append(location)
//
//        if viewModel.devices[index].coordinates.count > 50 {
//            viewModel.devices[index].coordinates.removeFirst()
//        }
//         let coords = CLLocationCoordinate2D(latitude: viewModel.devices[index].coordinates.last!.coordinate.latitude, longitude: viewModel.devices[index].coordinates.last!.coordinate.longitude)
//         mapView.animate(toLocation: coords)
//    
//        drawing.drawPolylinesOn(mapView, forLocations: viewModel.devices[index].coordinates, forDevice: viewModel.devices[index])
        //viewModel.drawPolylines(forMap: mapView)
//    }
}

//MARK: - MapViewDelegates -
extension ViewController: GMSMapViewDelegate {
    
}
