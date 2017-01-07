//
//  GoogleMapViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/23.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class GoogleMapViewController: UIViewController{

    
//    var placesClient: GMSPlacesClient!
//
//    
//    @IBOutlet var placePicker: GMSPlacePicker!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!{
        didSet{
            mapView.delegate = self
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    let locationManager = LocationManager.sharedInstance
    let dataProvider = GoogleDataProvider()
    let searchRadius: Double = 10
    var didFindMyLocation = false
    var selectRubbish = Rubbish()
    var didTruckMade = false
    var googleIconView = GoogleIconView(frame: CGRectMake(10,100,100,100))
    var iconRotation = Float()
    var markers = [GMSMarker]()
    let geoCoder = CLGeocoder()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        searchPlace(selectRubbish)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleIconView.delegate = self
        googleIconView.backgroundColor = UIColor.whiteColor()
        googleIconView.hidden = true
        locationManager.mapView = mapView
        
        mapView.addSubview(googleIconView)

    }
    
    func searchPlace(selectRubbish:Rubbish){
        if !didTruckMade {
        geoCoder.geocodeAddressString(selectRubbish.location, completionHandler: {
            (placemarks,error) -> Void in
            if error != nil{
                print(error)
                return
            }
            //   delete self googlemap search
//            if placemarks != nil && placemarks!.count > 0{
//                let placemark = placemarks![0] as CLPlacemark
//                self.setupMark(placemark)
//                self.setupRegionDetect(placemark)
//                self.drawTheLine()
//                    }
                })
            
            let trucklocationCoordinate2D = CLLocationCoordinate2DMake(selectRubbish.latitude, selectRubbish.longitude)
            self.setupMark(trucklocationCoordinate2D)
            self.drawTheLine()
            didTruckMade = true
        }
        else{
            mapView.camera = GMSCameraPosition(target: (locationManager.truckLocation), zoom: 15, bearing: 10, viewingAngle: 10)
        }
    }
    
    func setupMark(locationCoordinate:CLLocationCoordinate2D){
        let marker = GMSMarker(position: locationCoordinate)
        // put location into trucklocation
        self.locationManager.truckLocation = locationCoordinate
        marker.title = selectRubbish.location
        marker.snippet = selectRubbish.car
        marker.groundAnchor = CGPointMake(0.5, 0.5)
        let pinview = UIImage(named: "trushtruck0.10x")
        marker.icon = pinview
        marker.rotation = Double(self.iconRotation)
        self.mapView.camera = GMSCameraPosition(target: locationCoordinate, zoom: 15, bearing: 10, viewingAngle: 10)
        marker.map = self.mapView
        markers += [marker]
        
    }
    
    func setupRegionDetect(placemarkL:CLPlacemark){
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion.self){
            let title = "Lorrenzillo's"
            let coordinate = (placemarkL.location?.coordinate)!
            let regionRadius = 300.0
            let region = CLCircularRegion(center: CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude), radius: regionRadius, identifier: title)
            self.locationManager.locationManager.startMonitoringForRegion(region)
            let restaurantAnnotation = GMSMarker(position: coordinate)
            restaurantAnnotation.title = "\(title)"
            for (_,marker) in markers.enumerate() {
                marker.map = mapView
            }
            
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
        
        for regionIdentifier in locationManager.monitoredRegions.keys {
            
            // 3.
            if NSDate().timeIntervalSinceDate(locationManager.monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                showAlert("", message: "Your TrushTruck Approach")
                regionsToDelete.append(regionIdentifier)
            }
        }
        // 4.
        for regionIdentifier in regionsToDelete {
            locationManager.monitoredRegions.removeValueForKey(regionIdentifier)
        }
    }
    
    func drawTheLine(){
        
        let path = GMSMutablePath()
        path.addCoordinate(locationManager.userLocation)
        path.addCoordinate(locationManager.truckLocation)
        print(path)
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.strokeColor = UIColor.blueColor()
        rectangle.map = mapView
    }
    
    func showAlert(title:String?,message:String){
        let alerview = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style:.Cancel , handler: nil)
        alerview.addAction(action)
        self.presentViewController(alerview, animated: true, completion: nil)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            self.addressLabel.unlock()
            if let address = response?.firstResult() {
                let lines = address.lines
                //                print(address.country! + address.locality!)
                self.addressLabel.text = lines!.joinWithSeparator("\n")
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
            }
        }
    }
    
    
}

extension GoogleMapViewController:GoogleIconViewDelegate{
    func silderDidSlide(googleIconView: GoogleIconView, sliderValue: Float) {
        iconRotation = sliderValue
        print(iconRotation)
        for (_ ,marker) in markers.enumerate() {
        marker.rotation = Double(self.iconRotation)
        }
    }
}


extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(googleMap: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        marker.rotation = Double(self.iconRotation)
//        googleIconView.hidden = false
        return false
    }
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
//        googleIconView.hidden = true
    }
    func googleView(hide:Bool){
        if hide {
            googleIconView.hidden = hide
        }
        else{
            googleIconView.hidden = hide
        }
    }

    
}

