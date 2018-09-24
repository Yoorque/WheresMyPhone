//
//  Drawing.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import GoogleMaps

class Drawing {
    
    var polylines = [GMSOverlay]()
    let phoneMarker = GMSMarker()
    let startMarker = GMSMarker()
    let endMarker = GMSMarker()
    var camera: GMSCameraPosition!
    var iconView: UIView! {
        didSet {
            let label = UILabel()
            label.textAlignment = .center
            label.frame = iconView.frame
            iconView.addSubview(label)
        }
    }
    
    func drawPolylinesOn(_ mapView: GMSMapView, forDevice device: Device) {
        
        phoneMarker.position = CLLocationCoordinate2D(latitude: device.coordinates.last!.latitude, longitude: device.coordinates.last!.longitude)

        let path = GMSMutablePath()
        var speed: Double = 0.0
        var startLocation: CLLocation!
        var endLocation: CLLocation!
        var index = 0
        
        //Create new path for every 2 (two) last coordinates in order to observe the speed and color the segment accordingly
        device.coordinates.suffix(2).forEach {
            if index == 0 {
                startLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: $0.timestamp)
                index += 1
            } else {
                endLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: $0.timestamp)
            }
            path.add(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        }
        
        let distance = endLocation.distance(from: startLocation)
        let timeInterval = endLocation.timestamp.timeIntervalSince(startLocation.timestamp)
        speed = distance / timeInterval
        
        //create polylines from GMSPath consisting of last two coordinates of device locations
        let polyline = GMSPolyline(path: path)
        polyline.title = device.name
        polyline.strokeWidth = 3
        polyline.geodesic = true
        polyline.strokeColor = speedColors(forSpeed: speed) //color polyline segment, depending on the speed
        polyline.map = mapView
        
        phoneMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5) //lower the default position of the marker in relation to 'blue dot' representing current device location, so that the marker covers the dot.
        phoneMarker.icon = device.image
        phoneMarker.title = device.name
        phoneMarker.snippet = speed.toStringOfkmPerHour() //convert speed 'Double' to return String
        phoneMarker.map = mapView
        phoneMarker.tracksInfoWindowChanges = true //monitors changes in infoWindow and updates it once new data arrives
        
        polylines.append(polyline) //append created polyline segment to polyline array for storage, so it can be cleared by device.name property
        polylines.append(phoneMarker) //append created marker segment to polyline array for storage, so it can be cleared by device.name property
        history(forDeviceTitle: device.name, onMap: mapView) //retrieve historical data saved in polylines array, for selected device
    }
    
    //historical data for a selected device
    private func history(forDeviceTitle title: String, onMap map: GMSMapView) {
        polylines.forEach {
            if $0.title == title {
                $0.map = map
            }
        }
    }
    
    func addCustomIconWithText(_ text: String, andColor color: UIColor) -> UIView {
        iconView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 20)))
        for subview in iconView.subviews {
            if subview.isKind(of: UILabel.self) {
                let label = iconView.subviews.first as! UILabel
                label.backgroundColor = color.withAlphaComponent(0.3)
                label.text = text
            }
        }
        return iconView
    }
    
    func drawDateRangePolylinesFor(_ device: Device, mapView: GMSMapView, between startLocation: CLLocation, and endLocation: CLLocation) {
        polylines.forEach {
            if $0.title == device.name + "range" {
                $0.map = nil
            }
        }
        let path = GMSMutablePath()
        
        let eligibleLocations = device.coordinates.filter {$0.timestamp >= startLocation.timestamp && $0.timestamp <= endLocation.timestamp}
        
        for coords in eligibleLocations {
            path.add(CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude))
            
            print(eligibleLocations.count)
        }
        
        
        
        
        startMarker.position = CLLocationCoordinate2D(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
        endMarker.position = CLLocationCoordinate2D(latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
        
        startMarker.iconView = addCustomIconWithText(startLocation.timestamp.formatForTime(), andColor: UIColor.green)
        endMarker.iconView = addCustomIconWithText(endLocation.timestamp.formatForTime(), andColor: UIColor.red)
        
        startMarker.title = startLocation.timestamp.formatDate()
        endMarker.title = endLocation.timestamp.formatDate()
        
        startMarker.map = mapView
        endMarker.map = mapView
        
        let polyline = GMSPolyline(path: path)
        polyline.title = device.name + "range"
        polyline.strokeColor = .cyan
        polyline.strokeWidth = 5
        polyline.geodesic = true
        polyline.map = mapView
        polylines.append(polyline)
    }
    
    func clearRangePolylines() {
        for polyline in polylines {
            if polyline.title!.contains("range") {
                polyline.map = nil
                startMarker.map = nil
                endMarker.map = nil
            }
        }
    }
    
    //set polylines for removed device to nil
    func removePolylinesFor(_ name: String) {
        for polyline in polylines {
            if polyline.title!.contains(name) {
                polyline.map = nil //setting polyline map to nil
            }
        }
        //Uncomment to delete polylines for selected device, permanently. Otherwise, historical location data will be preserved between sessions
        cleanUpPolylinesFor(name)
    }
    
    //clean-up polylines for removed device
    private func cleanUpPolylinesFor(_ deviceName: String) {
        polylines = polylines.filter {$0.title != deviceName}
    }
    
    //choose polyline segment color depending on the speed for that segment
    private func speedColors(forSpeed speed: Double) -> UIColor{
        switch speed {
        case 0..<5:
            return .blue
        case 5..<10:
            return .green
        case 10..<15:
            return .orange
        case 15..<20:
            return .red
        case 20..<25:
            return .purple
        default:
            return .black
        }
    }
}
