//
//  Rubbish.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/16.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import Foundation


class Rubbish {
    private var _car:String!
    private var _lineid:String!
    private var _location:String!
    private var _time:String!
    
    var car:String{
        return _car
    }
    var lineid:String{
        return _lineid
    }
    var location:String{
        return _location
    }
    var time:String{
        return _time
    }
    init(dictionary: Dictionary<String,AnyObject>?){
        if let dictionary = dictionary {
        
        if let car = dictionary["car"]as? String {
            self._car = car
            }
        if let lineid = dictionary["lineid"]as? String{
            self._lineid = lineid
            }
        if  let location = dictionary["location"]as? String{
            self._location = location
            }
        if let time = dictionary["time"]as? String {
            self._time = time
            }
        
        }
    }
    
}