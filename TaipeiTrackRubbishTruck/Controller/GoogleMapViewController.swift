//
//  GoogleMapViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/23.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import MapKit

class GoogleMapViewController: UIViewController {

    
    var placesClient: GMSPlacesClient!
    
    @IBOutlet var placePicker: GMSPlacePicker!
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    let searchRadius: Double = 1000
    var didFindMyLocation = false
    var selectRubbish = Rubbish(dictionary: nil)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()

        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true

//        mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        placesClient = GMSPlacesClient()
        searchPlace(selectRubbish)

    }
    func dismissForGoogleStreetView(sender: GoogleStreetView) {
        
    }
    @IBAction func getCurrentPlace(sender: UIButton) {
        
        placesClient?.currentPlaceWithCallback({
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLicklihoodList = placeLikelihoodList {
                let place = placeLicklihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress!.componentsSeparatedByString(", ")
                        .joinWithSeparator("\n")
                }
            }
        })
    
    }
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if !didFindMyLocation {
//            let myLocation : CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
//            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
//            mapView.settings.myLocationButton = true
//            didFindMyLocation = true
//        }
//    }
   

    @IBAction func pickPlace(sender: UIBarButtonItem) {
        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place attributions \(place.attributions)")
            } else {
                print("No place selected")
            }
        })
    }
    func searchPlace(selectRubbish:Rubbish?){
        if let selectRubbish  = selectRubbish {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(selectRubbish.location, completionHandler: {
            (placemarks,error) -> Void in
            if error != nil{
                print(error)
                return
            }
            if placemarks != nil && placemarks!.count > 0{
                let placemark = placemarks![0] as CLPlacemark
                print(placemark.location)
                let marker = GMSMarker(position: (placemark.location?.coordinate)!)
                marker.title = selectRubbish.location
                marker.snippet = selectRubbish.car
                marker.map = self.mapView
                let pinview = UIImage(named: "trushtruck0.10x")
                marker.icon = pinview
                self.mapView.camera = GMSCameraPosition(target: (placemark.location?.coordinate)!, zoom: 15, bearing: 10, viewingAngle: 10)
                }
            })
        }

    }

}


extension GoogleMapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: \(error.description)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            self.addressLabel.unlock()
            if let address = response?.firstResult() {
                let lines = address.lines 
                self.addressLabel.text = lines!.joinWithSeparator("\n")
                
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
            }
        }
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                let marker = PlaceMarker(place: place)
                marker.map = self.mapView
            }
        }
    }
}

extension GoogleMapViewController:CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        }

    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            
             mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
            
        }
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    }
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
