//
//  PlaceMarker.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/7/25.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
    }
}
