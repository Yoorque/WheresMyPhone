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
    
    
    func displayDevice(_ device: DeviceViewModel) {
        
        let coordinate2D = CLLocationCoordinate2D(latitude: device.coordinates.last!.latitude, longitude: device.coordinates.last!.longitude)
        phoneMarker.position = coordinate2D
        phoneMarker.map = mapView
//        mapView.camera = GMSCameraPosition(target: phoneMarker.position, zoom: mapView.layer.cameraZoomLevel, bearing: mapView.layer.cameraBearing, viewingAngle: mapView.layer.cameraViewingAngle)
        phoneMarker.title = device.name
        phoneMarker.snippet = device.coordinates.last!.timestamp
    }
    
    func drawPolylinesFor(_ device: DeviceViewModel) {
        
        let camera = GMSCameraPosition(target: mapView.camera.target, zoom: mapView.camera.zoom, bearing: mapView.camera.bearing, viewingAngle: mapView.camera.bearing)
        mapView.animate(to: camera) //animate camera to center on current/last device location
        
        let path = GMSMutablePath()
        var speed: Double = 0.0
        //Create new path for every 2 (two) last coordinates in order to observe the speed and color the segment accordingly
        var counter = 0
        var startLocation = CLLocation()
        var endLocation = CLLocation()
        device.coordinates.suffix(2).forEach {
            path.add(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
            
            if counter == 0 {
            startLocation = CLLocation(latitude: device.coordinates.first!.latitude, longitude: device.coordinates.first!.longitude)
                counter += 1
            } else {
            
             endLocation = CLLocation(latitude: device.coordinates.last!.latitude, longitude: device.coordinates.last!.longitude)
                counter = 0
            }
        }
        //Speed calculation
        let distance = endLocation.distance(from: startLocation)
        let time = endLocation.timestamp.timeIntervalSince(startLocation.timestamp)
        speed = distance / time
        
        
        //create polylines from GMSPath consisting of last two coordinates of device locations
        let polyline = GMSPolyline(path: path)
        polyline.title = device.name
        polyline.strokeColor = speedColors(forSpeed: speed)
        polyline.strokeWidth = 3
        polyline.geodesic = true
        //polyline.strokeColor = speedColors(forSpeed: speed) //color polyline segment, depending on the speed
        polyline.map = mapView
        
       // phoneMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5) //lower the default position of the marker in relation to 'blue dot' representing current device location, so that the marker covers the dot.
        
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
    
    //set polylines for removed device to nil
    func removePolylinesFor(_ device: Device) {
        for polyline in polylines {
            if polyline.title == device.name {
                polyline.map = nil //setting polyline map to nil
            }
        }
        cleanUpPolylinesFor(device)
    }
    
    //clean-up polylines for removed device
    private func cleanUpPolylinesFor(_ device: Device) {
        polylines = polylines.filter {$0.title != device.name}
    }
    
    //choose polyline segment color depending on the speed for that segment
    private func speedColors(forSpeed speed: Double) -> UIColor{
        switch speed {
        case 0..<2:
            return .blue
        case 2..<4:
            return .green
        case 4..<6:
            return .orange
        case 6..<8:
            return .red
        case 8..<10:
            return .purple
        default:
            return .black
        }
    }
}
