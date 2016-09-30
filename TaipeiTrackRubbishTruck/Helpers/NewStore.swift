//
//  NewStore.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/9/26.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class NewsStore: NSObject {
    
    private static var myInstance :NewsStore?
    
    static func sharedInstance() ->NewsStore {
        if myInstance == nil{
            myInstance = NewsStore()
        }
        return myInstance!
    }
    
    var items : [NewsItem] = []
    override init() {
        super.init()
        self.loadItemsFromCache()
    }
    func addItems(newItem:NewsItem){
        items.insert(newItem, atIndex: 0)
        saveItemsToCache()
    }
}
extension NewsStore{
    var itemsCachePath:String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent("new.dat")
        return (fileURL?.path!)!
    }
    
    func saveItemsToCache(){
        NSKeyedArchiver.archiveRootObject(items, toFile: itemsCachePath)
    }
    func loadItemsFromCache(){
       if let cachedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemsCachePath) as? [NewsItem]{
            items  = cachedItems
        }
    }
    
}
