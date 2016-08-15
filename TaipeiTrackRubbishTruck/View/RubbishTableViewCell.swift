//
//  RubbishTableViewCell.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/16.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

@objc protocol RubbishTableCellDelegate {
    func RubbishCelldidselected(RubbishCell:RubbishTableViewCell)
}

class RubbishTableViewCell: UITableViewCell {

    var buttondelegate : RubbishTableCellDelegate?
    @IBAction func buttomTap(sender: UIButton) {
        if buttondelegate != nil{
            self.buttondelegate?.RubbishCelldidselected(self)
        }
    }
    var rubbish:Rubbish!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var lineId: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(rubbish:Rubbish){
        self.rubbish = rubbish
        self.locationLabel.text = rubbish.location
        self.carLabel.text = rubbish.car
//        self.lineId.text = String(rubbish.lineid)
        self.timeLabel.text = rubbish.time
    }
}
