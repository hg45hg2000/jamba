//
//  GoogleMapViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/23.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController,GMSMapViewDelegate,GoogleStreetViewDelegate {

    
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    var mapsArray = [GMSMapView]()
    
    override func loadView() {
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: GMSCameraPosition.cameraWithLatitude(1.285, longitude: 103.848, zoom: 12))
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        let position = CLLocationCoordinate2DMake(48.858,2.294)
        let marker = GMSMarker(position: position)
        let panoView = GMSPanoramaView(frame: CGRect.zero)
        // Add the marker to a GMSPanoramaView object named panoView
        marker.panoramaView = panoView
        
        // Add the marker to a GMSMapView object named mapView
        marker.map = mapView
        mapsArray.append(mapView)
        self.view = mapView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    // MARK: GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let panoView = GoogleStreetView(frame: CGRect.zero)
        panoView.delegates = self
        self.view = panoView
//        panoView.moveNearCoordinate(marker.position)
        
        return true
    }
    func dismissForGoogleStreetView(_ sender: GoogleStreetView) {
        
    }

    
}
extension GoogleMapViewController :GMSPanoramaViewDelegate {
    
}


//extension GoogleMapViewController:CLLocationManagerDelegate{
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse{
//            locationManager.startUpdatingLocation()
////            googleMap.myLocationEnabled = true
////            googleMap.settings.myLocationButton = true
//    }
//        else {
//            print("open location setting ")
//        }
//
//    }
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first{
////            googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            
//            locationManager.stopUpdatingLocation()
//        }
//    }
//}

//extension GoogleMapViewController: GMSMapViewDelegate {
//    func mapView(googleMap: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
//        reverseGeocodeCoordinate(position.target)
//    }
//    
//    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
//        addressLabel.lock()
//        
//        if (gesture) {
//            mapCenterPinImage.fadeIn(0.25)
//            mapView.selectedMarker = nil
//        }
//    }
//    
//    func mapView(googleMap: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
//        let placeMarker = marker as! PlaceMarker
//        
//        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
//            infoView.nameLabel.text = placeMarker.place.name
//            
//            if let photo = placeMarker.place.photo {
//                infoView.placePhoto.image = photo
//            } else {
//                infoView.placePhoto.image = UIImage(named: "generic")
//            }
//            
//            return infoView
//        } else {
//            return nil
//        }
//    }
//    
//    func mapView(googleMap: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
////        mapCenterPinImage.fadeOut(0.25)
//        return false
//    }
//    
//    func didTapMyLocationButtonForMapView(googleMap: GMSMapView!) -> Bool {
////        mapCenterPinImage.fadeIn(0.25)
//        googleMap.selectedMarker = nil
//        return false
//    }
//}
