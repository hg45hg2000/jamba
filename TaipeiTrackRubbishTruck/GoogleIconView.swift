//
//  GoogleIconView.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/8/2.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

protocol GoogleIconViewDelegate : class{
    func silderDidSlide(GoogleIconView:GoogleIconView,sliderValue:Float)
}

class GoogleIconView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var slider = UISlider(){
        didSet{
            slider.maximumValue = 360
            slider.minimumValue = 0
            slider.continuous = true
        }
    }
    var dismissButton = UIButton(){
        didSet{
            dismissButton.setTitle("cancel", forState: .Normal)
            dismissButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            dismissButton.titleLabel?.textColor = UIColor.blueColor()
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    weak var delegate : GoogleIconViewDelegate?
    var ButtonWidth :CGFloat?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupSlider()
        setupDismissButton()
        setupButtonlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     func sliderdidchage(slider:UISlider){
        
        self.delegate?.silderDidSlide(self, sliderValue: slider.value)
        
    }
    func dismissButtonPress(button:UIButton){
        self.hidden = true
    }
    func setupSlider(){
        slider.addTarget(self, action: #selector(GoogleIconView.sliderdidchage(_:)), forControlEvents: .ValueChanged)
        self.addSubview(slider)
    }
    func setupDismissButton(){
        dismissButton.addTarget(self, action: #selector(GoogleIconView.dismissButtonPress(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(dismissButton)
    }
    
    func setupButtonlayout(){
        self.addConstraint(NSLayoutConstraint(item: self.dismissButton, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.6, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.dismissButton, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.6, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.dismissButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.dismissButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
   
}
