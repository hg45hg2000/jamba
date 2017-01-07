//
//  LocationManager.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/9/8.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject {

    class var sharedInstance : LocationManager {
        
        struct Static {
            static let instance : LocationManager = LocationManager()
        }
        return Static.instance
    }
    var truckLocation = CLLocationCoordinate2D()
    var userLocation = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    
    var userBetweenTruckArray = [CLLocationCoordinate2D]()
    
    var monitoredRegions : Dictionary<String,NSDate>  = [:]
    var mapView = GMSMapView()
    
    private override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorization()
        
    }
    
        func checkAuthorization(){
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                locationManager.requestAlwaysAuthorization()
            case .Denied: break
            case .AuthorizedAlways:
                locationManager.startUpdatingLocation()
            default:break
            }
            
        }

}
extension LocationManager:CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            self.locationManager.startUpdatingLocation()
            self.mapView.myLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            
        }
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            userLocation = location.coordinate
            print(userLocation)
            locationManager.stopUpdatingLocation()
            
        }
    }
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        showAlert("", message: "enter \(region.identifier)")
        monitoredRegions = [region.identifier : NSDate()]
    }
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//        showAlert("", message: "eixt \(region.identifier)")
        monitoredRegions.removeValueForKey(region.identifier)
    }
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
}
