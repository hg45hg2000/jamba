//
//  NewTaipeiCell.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/8/4.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class NewTaipeiCell: UITableViewCell {

    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0.0, 0.04, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
