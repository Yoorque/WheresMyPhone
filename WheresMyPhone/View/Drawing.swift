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
    
    func drawPolylinesOn(_ mapView: GMSMapView, forDevice device: Device) {
        
        //mapView.clear()
        let path = GMSMutablePath()
        var speed: Double = 0.0
        
        //Iterate through locations array
        for (index, location) in device.coordinates.enumerated() {
            speed = location.speed
            print(device.coordinates.count)
            
            //Create new path for every 2 (two) last coordinates in order to observe the speed and color the segment accordingly
            if index >= device.coordinates.count - 3 {
                path.add(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.title = device.name
        polyline.strokeWidth = 3
        polyline.geodesic = true
        polyline.strokeColor = speedColors(forSpeed: speed)
        polyline.map = mapView
        phoneMarker.position = CLLocationCoordinate2D(latitude: device.coordinates.last!.coordinate.latitude, longitude: device.coordinates.last!.coordinate.longitude)
        phoneMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        phoneMarker.icon = UIImage(named: "iPhone")!.scaleImageTo(CGSize(width: 35, height: 40))
    
        phoneMarker.title = device.name
        phoneMarker.snippet = speed.toStringOfkmPerHour()
        phoneMarker.map = mapView
        phoneMarker.tracksInfoWindowChanges = true
        
        polylines.append(polyline)
        polylines.append(phoneMarker)
    }
    
    func removePolyline(forDeviceTitle title: String) {
        polylines.forEach {
            if $0.title == title {
                $0.map = nil
            }
        }
    }
    
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
