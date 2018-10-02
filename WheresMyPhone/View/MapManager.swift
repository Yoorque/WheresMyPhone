//
//  DeviceMapView.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import GoogleMaps

class MapManager: UIView {
    static var sharedInstance = MapManager()
    var mapView: GMSMapView!
    ///Creates GMSMapView on a parameter view.
    ///- Parameter view: View to which the map will be added as a subview.
    func createMapFor(_ view: UIView) {
        mapView = GMSMapView(frame: view.frame)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        view.addSubview(mapView)
    }
    
    func addMarkerFor(_ device: DeviceProtocol) {
        mapView.clear()
        let location = CLLocationCoordinate2D(latitude: device.coordinates.last!.latitude, longitude: device.coordinates.last!.longitude)
        let marker = GMSMarker(position: location)
        marker.title = device.name
        marker.snippet = device.uuid
        marker.map = mapView
        
        switch device.deviceType {
        case .CellPhone:
            marker.iconView = UIImageView(image: UIImage(named: "iPhone")?.scaleImageTo(CGSize(width: 30, height: 40)))
        case .SmartWatch:
            marker.iconView = UIImageView(image: UIImage(named: "iWatch")?.scaleImageTo(CGSize(width: 30, height: 40)))
        case .SmartBracelet:
            marker.iconView = UIImageView(image: UIImage(named: "iBracelet")?.scaleImageTo(CGSize(width: 30, height: 40)))
        case .Speaker:
            marker.iconView = UIImageView(image: UIImage(named: "iSpeaker")?.scaleImageTo(CGSize(width: 30, height: 40)))
        }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            marker.iconView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        })
    }
}
