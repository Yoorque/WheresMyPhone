//
//  MapManager.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import GoogleMaps

class MapManager: NSObject {
    var mapView: GMSMapView!
    var polylines = [GMSOverlay]()
    let phoneMarker = GMSMarker()
    
    ///Sets-up `GMSMapView` map in any UIViewController's subview, from which this method is called.
    ///- Parameter viewController: Source `UIViewController` from which this method is called.
    ///- Parameter view: `UIView` in which the map will be drawn.
    func setupMapFor(_ viewController: UIViewController, andView view: UIView) {
        mapView = GMSMapView(frame: view.frame)
        mapView.delegate = viewController as? GMSMapViewDelegate
        mapView.translatesAutoresizingMaskIntoConstraints = false //optional
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.settings.compassButton = true //displays compas on the map when map heading is changed
        mapView.settings.myLocationButton = true //displays round myLocation button
        mapView.isMyLocationEnabled = true //enables user location
        view.addSubview(mapView)
    }
    
    ///Draws a marker on the map at a last coordinate in device's coordinate array.
    ///- Parameter device: Device being tracked
    func displayDevice(_ device: DeviceViewModel) {
        let coordinate2D = CLLocationCoordinate2D(latitude: device.coordinates.last!.latitude, longitude: device.coordinates.last!.longitude)
        phoneMarker.position = coordinate2D
        phoneMarker.map = mapView
        phoneMarker.title = device.name
        phoneMarker.snippet = device.coordinates.last!.timestampString
        phoneMarker.icon = UIImage(named: "iPhone")?.scaleImageTo(CGSize(width: 30, height: 40))
    }
    
    ///Draws polylines on the map for passed-in device.
    func drawPolylinesFor(_ device: DeviceViewModel) {
        
        let camera = GMSCameraPosition(target: mapView.camera.target, zoom: mapView.camera.zoom, bearing: mapView.camera.bearing, viewingAngle: mapView.camera.bearing)
        mapView.animate(to: camera) //animate camera to center on current/last device location
        
        let path = GMSMutablePath()
        var speed: Double = 0.0
        var counter = 0
        var startLocation: CLLocation!
        var endLocation: CLLocation!
        
        //Create new path for every 2 (two) last coordinates in order to observe the speed and apply color to the segment accordingly.
        device.coordinates.suffix(2).forEach {
            
            //Using counter to differentiate between starting and ending location.
            if counter == 0 {
            startLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), altitude: 0, horizontalAccuracy: $0.accuracy, verticalAccuracy: $0.accuracy, course: 0, speed: 0, timestamp: $0.timestamp)
                counter += 1
            } else {
             endLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), altitude: 0, horizontalAccuracy: $0.accuracy, verticalAccuracy: $0.accuracy, course: 0, speed: 0, timestamp: $0.timestamp)
            }
            
             path.add(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        }
        
        //Speed calculation
        let distance = endLocation.distance(from: startLocation)
        let time = endLocation.timestamp.timeIntervalSince(startLocation.timestamp)
        speed = distance / time // Speed is in `m/s`
        
        //create polylines from GMSPath consisting of last two coordinates of device locations
        let polyline = GMSPolyline(path: path)
        polyline.title = device.name //Add device name to polyline title property, in order to be able to differentiate between polylines in a polyline array.
        polyline.strokeColor = UIColor.colorForSpeed(speed) //color polyline segment, depending on the speed and convert speed to `km/h` using UIColor extension.
        
        polyline.strokeWidth = 3
        polyline.geodesic = true
        polyline.map = mapView
        
       // phoneMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5) //lower the default position of the marker in relation to 'blue dot' representing current device location, so that the marker covers the dot.
        
        phoneMarker.title = device.name
        phoneMarker.snippet = speed.toStringOfkmPerHour() //convert speed 'Double' to return 'String' and also convert from `m/s` to `km/h`.
        phoneMarker.map = mapView
        phoneMarker.tracksInfoWindowChanges = true //monitors changes in infoWindow and updates it once new data arrives
        
        polylines.append(polyline) //append created polyline segment to polyline array for storage, so it can be cleared by device.name property
        polylines.append(phoneMarker) //append created marker segment to polyline array for storage, so it can be cleared by device.name property
       // history(forDeviceName: device.name, onMap: mapView) //retrieve historical data saved in polylines array, for selected device
    }
    
    ///Historical data for a selected device.
    ///- Parameter name: Name of the device.
    ///- Parameter map: Map on which to display polylines.
    ///- Note: Matches all of the polylines with device name and draws them from the polylines array.
    private func history(forDeviceName name: String, onMap map: GMSMapView) {
        polylines.forEach { //Loop through all polylines
            if $0.title == name { //Compare device name and polyline title.
                $0.map = map // Set polyline map property to passed-in map object in order to draw it.
            }
        }
    }
    
    //set polylines for removed device to nil
    func removePolylinesFor(_ device: Device) {
        polylines.forEach { //Loop through all polylines
            if $0.title == device.name { //Compare device name and polyline title.
                $0.map = nil //Temporarily remove polylines from map by setting polyline map to nil,
            }
        }
        cleanUpPolylinesFor(device)
    }
    
    //clean-up polylines for removed device
    private func cleanUpPolylinesFor(_ device: Device) {
        polylines = polylines.filter {$0.title != device.name} //Permanently removes all polylines for a passed-in device.
    }
}
