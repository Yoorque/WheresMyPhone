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
        var counter = 0 //Used to diferentiate between start and end locations
        
        //Create new path for every 2 (two) last coordinates in order to observe the speed and color the segment accordingly
        device.coordinates.suffix(2).forEach {
            //Depending on the counter value, different Location is populated with data in order to create both start and end locations
            //Counter 0 populates startLocation as the first item in the filtered array
            //Counter 1 populates endLocation as the last item in the filtered array
            if counter == 0 {
                startLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: $0.timestamp)
                counter += 1
            } else {
                endLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: $0.timestamp)
            }
            //Adds 2 locations (one for each iteration)
            path.add(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        }
        
        let distance = endLocation.distance(from: startLocation) //Calculate distance between 2 locations in meters
        let timeInterval = endLocation.timestamp.timeIntervalSince(startLocation.timestamp) //Calculates time difference between to timestamps in seconds
        speed = distance / timeInterval //Calculates speed in m/s
        
        //Create polylines from GMSPath consisting of last two coordinates of device locations
        let polyline = GMSPolyline(path: path)
        polyline.title = device.name
        polyline.strokeWidth = 3
        polyline.geodesic = true
        polyline.strokeColor = speedColors(forSpeed: speed) //Color polyline segment, depending on the speed
        polyline.map = mapView
        
        phoneMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5) //Lower the default position of the marker in relation to 'blue dot' representing current device location, so that the marker covers the dot.
        phoneMarker.icon = device.image
        phoneMarker.title = device.name
        phoneMarker.snippet = speed.toStringOfkmPerHour() //Convert speed in m/s to return km/h as a String
        phoneMarker.map = mapView
        phoneMarker.tracksInfoWindowChanges = true //Monitors changes in infoWindow and updates it once new data arrives
        
        polylines.append(polyline) //Append created polyline segment to polyline array for storage, so it can be cleared by device.name property
        polylines.append(phoneMarker) //Append created marker segment to polyline array for storage, so it can be cleared by device.name property
        history(forDeviceTitle: device.name, onMap: mapView) //Retrieve historical data saved in polylines array, for selected device
    }
    
    //Historical data for a selected device
    private func history(forDeviceTitle title: String, onMap map: GMSMapView) {
        polylines.forEach {
            if $0.title == title {
                $0.map = map
            }
        }
    }
    
    //Add custom marker icon for Start and End markers
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
    
    //Used for drawing polylines between two passed-in locations
    func drawDateRangePolylinesFor(_ device: Device, mapView: GMSMapView, between startLocation: CLLocation, and endLocation: CLLocation) {
        //Initialy clear the range overlays before drawing new ones
        clearRangePolylines()
        
        //Instantiate path for polylines
        let path = GMSMutablePath()
        
        //Filter for eligible coordinates between given dates
        let eligibleLocations = device.coordinates.filter {$0.timestamp >= startLocation.timestamp && $0.timestamp <= endLocation.timestamp}
        
        //Iterate through eligible coordinates and add them to 'path'
        for coords in eligibleLocations {
            path.add(CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude))
        }
        
        //Instantiate Start and End markers
        startMarker.position = CLLocationCoordinate2D(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
        startMarker.iconView = addCustomIconWithText(startLocation.timestamp.formatForTime(), andColor: UIColor.green)
        startMarker.title = startLocation.timestamp.formatDate()
        startMarker.map = mapView

        endMarker.position = CLLocationCoordinate2D(latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
        endMarker.iconView = addCustomIconWithText(endLocation.timestamp.formatForTime(), andColor: UIColor.red)
        endMarker.title = endLocation.timestamp.formatDate()
        endMarker.map = mapView
        
        //Create polylines and set properties
        let polyline = GMSPolyline(path: path)
        polyline.title = device.name + "range"
        polyline.strokeColor = .cyan
        polyline.strokeWidth = 5
        polyline.geodesic = true
        polyline.map = mapView
        polylines.append(polyline)
    }
    
    //Clear polylines that contain 'range' string in order to clear range overlays by setting map properties to nil
    func clearRangePolylines() {
        for polyline in polylines {
            if polyline.title!.contains("range") {
                polyline.map = nil
                startMarker.map = nil
                endMarker.map = nil
            }
        }
    }
    
    //Set polylines for removed device to nil
    func removePolylinesFor(_ name: String) {
        for polyline in polylines {
            if polyline.title!.contains(name) {
                polyline.map = nil //setting polyline map to nil
            }
        }
        //Uncomment to delete polylines for selected device, permanently. Otherwise, historical location data will be preserved between sessions
        cleanUpPolylinesFor(name)
    }
    
    //Clean-up polylines for removed device
    private func cleanUpPolylinesFor(_ deviceName: String) {
        polylines = polylines.filter {$0.title != deviceName}
    }
    
    //Choose polyline segment color depending on the speed for that segment
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
