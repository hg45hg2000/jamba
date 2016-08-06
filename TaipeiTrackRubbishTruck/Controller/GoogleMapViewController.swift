//
//  GoogleMapViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/23.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import MapKit

class GoogleMapViewController: UIViewController{

    
    var placesClient: GMSPlacesClient!
    
    
    @IBOutlet var placePicker: GMSPlacePicker!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!{
        didSet{
            mapView.delegate = self
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    let searchRadius: Double = 1000
    var didFindMyLocation = false
    var selectRubbish = Rubbish(dictionary: nil)
    
    
    var googleIconView = GoogleIconView(frame: CGRectMake(10,100,100,100))
    var iconRotation = Float()
    var marker = GMSMarker()
    
    var monitoredRegions : Dictionary<String,NSDate>  = [:]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        googleIconView.delegate = self
        googleIconView.backgroundColor = UIColor.whiteColor()
        googleIconView.hidden = true
        
        
        mapView.addSubview(googleIconView)

        placesClient = GMSPlacesClient()
        searchPlace(selectRubbish)
    

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
    
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .Denied:
            showAlert("", message: "Location services were previously denied. Please enable location services for this app in Settings.")
        case .AuthorizedAlways:
            locationManager.startUpdatingLocation()
        default:break
        }
        
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
                self.marker = GMSMarker(position: (placemark.location?.coordinate)!)
                self.marker.title = selectRubbish.location
                self.marker.snippet = selectRubbish.car
                self.marker.map = self.mapView
                self.marker.groundAnchor = CGPointMake(0.5, 0.5)
                let pinview = UIImage(named: "trushtruck0.10x")
                self.marker.icon = pinview
                self.marker.rotation = Double(self.iconRotation)
                self.mapView.camera = GMSCameraPosition(target: (placemark.location?.coordinate)!, zoom: 15, bearing: 10, viewingAngle: 10)
                //
                self.setupData(placemark)
                }
            })
        }
    }
    
    func showAlert(title:String?,message:String){
        let alerview = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style:.Cancel , handler: nil)
        alerview.addAction(action)
        self.presentViewController(alerview, animated: true, completion: nil)
    }
    func setupData(placemarkL:CLPlacemark){
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion.self){
            let title = "Lorrenzillo's"
            let coordinate = (placemarkL.location?.coordinate)!
            let regionRadius = 300.0
            let region = CLCircularRegion(center: CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoringForRegion(region)
            
            let restaurantAnnotation = GMSMarker(position: coordinate)
            restaurantAnnotation.title = "\(title)";
            marker.map = mapView
            let circle = GMSCircle(position: (placemarkL.location?.coordinate)!, radius: regionRadius)
            circle.map = mapView

        }
        else{
            print("The system can't track regions")
        }
    }
    // DrawView
    func mapView(mapView:GMSMapView,rendererForOverlay:MKOverlay){
        let circleRenderer = MKCircleRenderer(overlay: rendererForOverlay)
        circleRenderer.strokeColor = UIColor.redColor()
        circleRenderer.lineWidth = 1.0
    }
    
    func updateRegions(){
        let regionMaxVisiting = 10.0
        var regionsToDelete: [String] = []
        
        for regionIdentifier in monitoredRegions.keys {
            
            // 3.
            if NSDate().timeIntervalSinceDate(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                showAlert("", message: "Your TrushTruck Approach")
                regionsToDelete.append(regionIdentifier)
            }
        }
        
        // 4.
        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValueForKey(regionIdentifier)
        }
    }
    
}
extension GoogleMapViewController:GoogleIconViewDelegate{
    func silderDidSlide(googleIconView: GoogleIconView, sliderValue: Float) {
        iconRotation = sliderValue
        print(iconRotation)
        marker.rotation = Double(self.iconRotation)
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
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert("", message: "enter \(region.identifier)")
        monitoredRegions = [region.identifier : NSDate()]
    }
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert("", message: "eixt \(region.identifier)")
        monitoredRegions.removeValueForKey(region.identifier)
    }
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(googleMap: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        marker.rotation = Double(self.iconRotation)
        googleIconView.hidden = false
        return false
    }
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        googleIconView.hidden = true
    }

    
}

