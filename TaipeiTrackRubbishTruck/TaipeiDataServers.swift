//
//  TaipeiDataServers.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/7/25.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

let Rubbish_Api = "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000070-002"

//class records:NSObject{
//    var result = 
//}

class TapieiDataServers {
    
    class var sharedInstance : TapieiDataServers {
        struct Static {
            static var once_token : dispatch_once_t = 0
            static var instance : TapieiDataServers? = nil
        }
        dispatch_once(&Static.once_token) {
            Static.instance = TapieiDataServers()
        }
        return Static.instance!
    }
    
   
    
    
    func getTheTrushData( completion:(([JSON]?),failure:((NSError?)))-> Void){
        Alamofire.request(.GET,Rubbish_Api).validate().responseJSON { (response) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            switch response.result {
            case.Success(let value):
                let json = JSON(value)
                print(json["result"]["records"])
                let records = json["result"]["records"].arrayValue
                dispatch_async(dispatch_get_main_queue(), { 
                     completion(records, failure: nil)
                })
            case.Failure(let error):
              completion(nil, failure: error)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
    }
   

}
