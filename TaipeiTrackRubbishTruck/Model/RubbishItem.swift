//
//  RubbishItem.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/10/24.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class RubbishItem: NSObject {
    
    var longitude = Double()
    
    var latitude = Double()
    
    var car = String()
    
    var lineid = String()
    
    var location = String()
    
    var time = String()
    
    init(Dic:JSON?) {
        
    if let dic = Dic{
        self.longitude = dic["longitude"].doubleValue
        self.latitude = dic["latitude"].doubleValue
        self.car = dic["car"].stringValue
        self.lineid = dic["lineid"].stringValue
        self.location = dic["location"].stringValue
        self.time = dic["time"].stringValue
        }
    }
}
