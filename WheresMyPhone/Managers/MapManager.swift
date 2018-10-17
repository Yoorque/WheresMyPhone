//
//  DeviceMapView.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import GoogleMaps
import RxSwift

class MapManager: UIView, GMSMapViewDelegate {
    static var sharedInstance = MapManager()
    let deviceMarker = GMSMarker()
    var mapView: GMSMapView!
    var marker = GMSMarker()
    var polylinesArray = [GMSPolyline]()
    
    ///Creates GMSMapView on a parameter view.
    ///- Parameter view: View to which the map will be added to as a subview.
    func createMapFor(_ view: UIView) {
        mapView = GMSMapView(frame: view.frame)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        view.addSubview(mapView)
    }

    func drawRangeFor(_ coordinates: [CoordinateProtocol]) {
        removeRangePolylines()
        
        let path = GMSMutablePath()
        coordinates.forEach { coord in
            let coordinate = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            path.add(coordinate)
        }
        let polyline = GMSPolyline(path: path)
        polyline.geodesic = true
        polyline.title = "range"
        print(polyline.path!.count(), polyline.path!.count())
        polyline.spans = [GMSStyleSpan(color: .green, segments: 1), GMSStyleSpan(color: .white, segments: Double(polyline.path!.count()) - 3), GMSStyleSpan(color: .red, segments: 1)]
        polyline.strokeWidth = 4
        polyline.map = mapView
        polylinesArray.append(polyline)
    }
    
    func drawSyncPolylinesFor(_ coordinates: [CoordinateProtocol]) {
        removeSyncPolylines()
        
        let startLocation = CLLocationCoordinate2D(latitude: coordinates.first!.latitude, longitude: coordinates.first!.longitude)
        let endLocation = CLLocationCoordinate2D(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude)
        let path = GMSMutablePath()
        coordinates.forEach { coord in
            let coordinate = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            path.add(coordinate)
        }
        let polyline = GMSPolyline(path: path)
        polyline.geodesic = true
        polyline.strokeColor = .blue
        polyline.strokeWidth = 2
        polyline.map = mapView
        polyline.title = "sync"
        polylinesArray.append(polyline)
        let coordinateBounds = GMSCoordinateBounds(coordinate: startLocation, coordinate: endLocation)
        mapView.animate(with: GMSCameraUpdate.fit(coordinateBounds))
    }
    
    func removeSyncPolylines() {
        for polyline in polylinesArray {
            if polyline.title == "sync" {
                polyline.map = nil
            }
        }
        polylinesArray = polylinesArray.compactMap {$0}
    }
    
    func removeRangePolylines() {
        for polyline in polylinesArray {
            if polyline.title == "range" {
                polyline.map = nil
            }
        }
        polylinesArray = polylinesArray.compactMap {$0}
    }
    
    func trackDevice(_ device: DeviceProtocol) {
        print("Device:", device.name, device.uuid, device.coordinates.value.last!)
        let coordinateToDraw = CLLocationCoordinate2D(latitude: device.coordinates.value.last!.latitude, longitude: device.coordinates.value.last!.longitude)
        deviceMarker.position = coordinateToDraw
        
        deviceMarker.title = device.name
        deviceMarker.tracksInfoWindowChanges = true
        deviceMarker.icon = chooseIconImageFor(device)!.scaleImageTo(CGSize(width: 30, height: 40))
        deviceMarker.map = mapView
        mapView.camera = GMSCameraPosition.camera(withTarget: coordinateToDraw, zoom: 7)
    }
    
    func chooseIconImageFor(_ device: DeviceProtocol) -> UIImage? {
        switch device.name.lowercased() {
        case let x where x.contains("watch"):
            return UIImage(named: "iWatch")
        case let x where x.contains("bracelet"):
            return UIImage(named: "iBracelet")
        case let x where x.contains("speaker"):
            return UIImage(named: "iSpeaker")
        default:
            return UIImage(named: "iPhone")
        }
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition(target: location, zoom: 7, bearing: 0, viewingAngle: 0)
    }
    
}
