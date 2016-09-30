//
//  NewsItem.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/9/26.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import Foundation
import UIKit

final class NewsItem:NSObject{
    let title: String
    let date :NSDate
    
    init(title:String, date:NSDate) {
        self.title = title
        self.date = date
    }
}

extension NewsItem : NSCoding{
    
    struct CodingKeys {
        static let Title = "title"
        static let Date = "date"
    }
    func desciption()->NSString{
        return ("\(self.title) \(self.date)")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObjectForKey(CodingKeys.Title) as? String,
            let date = aDecoder.decodeObjectForKey(CodingKeys.Date) as? NSDate {
            self.init(title:title, date: date)
        }else{
            return nil
        }
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: CodingKeys.Title)
        aCoder.encodeObject(date, forKey: CodingKeys.Date)
    }
}
