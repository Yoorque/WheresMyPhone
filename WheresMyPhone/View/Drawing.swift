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
    
    func drawPolylinesOn(_ mapView: GMSMapView, forDevice device: Device, withZoom zoom: Float) {
        
        phoneMarker.position = CLLocationCoordinate2D(latitude: device.coordinates.last!.coordinate.latitude, longitude: device.coordinates.last!.coordinate.longitude)
        let camera = GMSCameraPosition(target: mapView.camera.target, zoom: mapView.camera.zoom, bearing: mapView.camera.bearing, viewingAngle: mapView.camera.bearing)
        mapView.animate(to: camera) //animate camera to center on current/last device location
        //mapView.clear()
        let path = GMSMutablePath()
        var speed: Double = 0.0
        
        //Create new path for every 2 (two) last coordinates in order to observe the speed and color the segment accordingly
        device.coordinates.suffix(2).forEach {
            speed = $0.speed
            path.add(CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))
        }
        
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
