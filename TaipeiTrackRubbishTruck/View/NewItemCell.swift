//
//  NewItemCell.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/9/28.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class NewItemCell: UITableViewCell {

    func updateWithNewsItem(item:NewsItem){
        self.textLabel?.text = item.title
        self.detailTextLabel?.text =  DateParser.displayString(fordate: item.date)
    }

}
