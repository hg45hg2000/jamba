//
//  Rubbish.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/16.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import Foundation
import RealmSwift


class Rubbish {
    static var sharedInstance = Rubbish()
     init(){
    }
    
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
    init(dictionary: JSON?){
        if let dictionary = dictionary {
        
        if let car = dictionary["car"].string {
            self._car = car
            }
        if let lineid = dictionary["lineid"].string{
            self._lineid = lineid
            }
        if  let location = dictionary["location"].string{
            self._location = location
            }
        if let time = dictionary["time"].string {
            self._time = time
            }
        
        }
    }
    
}

public class RubbishData:Object{
        
    public dynamic var car :String = ""
    public dynamic var lineid :String = ""
    public dynamic var location :String = ""
    public dynamic var time :String = ""
    
    public func fillwithRubbish (Rubbish:RubbishDataStruct){
        self.car = Rubbish.car
        self.lineid = Rubbish.lineid
        self.location = Rubbish.location
        self.time = Rubbish.time
    }
}
public struct RubbishDataStruct{
    public let car :String
    public let lineid :String
    public let location :String
    public let time :String
}
