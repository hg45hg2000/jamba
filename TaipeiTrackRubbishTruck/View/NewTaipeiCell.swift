//
//  NewTaipeiCell.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/8/4.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

protocol NewTaipeiAreaCell {
    func TaipeiAreaCellChange()
}

class NewTaipeiCell: UITableViewCell {

    let gradientLayer = CAGradientLayer()
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }

    
    @IBOutlet weak var areaLable: UILabel!
    @IBOutlet weak var NotificationView: UIImageView!
    
    private var images : UIImage? {
        get {
            return NotificationView.image
        }
        set {
            NotificationView.image = newValue
            NotificationView.sizeToFit()
            NotificationView.kt_addCorner(radius: 6)
            
        }
    }
    
    func fetchimage(){
        images = UIImage(named: "Truck")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.greenColor().CGColor
        //you can change the line width
        shapeLayer.lineWidth = 5.0
        
        NotificationView.layer.addSublayer(shapeLayer)
        fetchimage()
        NotificationView.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = lineWidth
        return path
    }
}
