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
    var marker = GMSMarker()
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
        marker = GMSMarker(position: location)
        marker.title = device.name
        marker.snippet = device.uuid
        marker.map = mapView
        
        switch device.name.lowercased() {
        case let n where n.contains("speaker"):
            marker.iconView = UIImageView(image: UIImage(named: "iSpeaker")?.scaleImageTo(CGSize(width: 30, height: 40)))
        case let n where n.contains("watch"):
            marker.iconView = UIImageView(image: UIImage(named: "iWatch")?.scaleImageTo(CGSize(width: 30, height: 40)))
        case let n where n.contains("bracelet"):
            marker.iconView = UIImageView(image: UIImage(named: "iBracelet")?.scaleImageTo(CGSize(width: 30, height: 40)))
        default:
            marker.iconView = UIImageView(image: UIImage(named: "iPhone")?.scaleImageTo(CGSize(width: 30, height: 40)))
        }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.marker.iconView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        })
    }
    
    func drawPolylinesFor(_ device: DeviceProtocol) {
        let path = GMSMutablePath()
        for coordinate in device.coordinates {
            path.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        let polylines = GMSPolyline(path: path)
        polylines.geodesic = true
        polylines.strokeWidth = 3
        polylines.map = mapView
        marker.position = CLLocationCoordinate2D(latitude: device.coordinates.last!.latitude, longitude: device.coordinates.last!.longitude)
    }
}
