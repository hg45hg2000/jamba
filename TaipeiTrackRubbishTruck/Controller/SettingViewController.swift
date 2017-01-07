//
//  SettingViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/8/6.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    let slider = UISlider()
    var label = UILabel()
    var tileGridView : TileGridView!
    var time = NSTimer()
    
    let animatedULogoView: AnimatedULogoView = AnimatedULogoView(frame: CGRect(x: 0.0, y: 0.0, width: 90.0, height: 90.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(slider)
        self.view.addSubview(label)
        label.text = "fuck you swift"
        setupSliderConstraint()
        setupLabelConstraint()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animation()
    }
    
    func animation(){
        tileGridView = TileGridView(TileFileName: "Chimes")
        self.view.addSubview(tileGridView)
        tileGridView.frame = view.bounds
        
        view.addSubview(animatedULogoView)
        animatedULogoView.layer.position = view.layer.position
        
        tileGridView.startAnimating()
        animatedULogoView.startAnimating()
        time = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(SettingViewController.removeAnimationView), userInfo: self, repeats: false)
        
    }
    func removeAnimationView(){
        tileGridView.removeFromSuperview()
        animatedULogoView.removeFromSuperview()
    }

    func setupSliderConstraint(){
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = UIColor.blueColor()
        slider.minimumValue = 0
        slider.maximumValue = 25
        slider.addTarget(self, action: #selector(SettingViewController.changelabelSize), forControlEvents: .ValueChanged)
        let topLayout = NSLayoutConstraint(item: slider, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0)
        let downLayout = NSLayoutConstraint(item: slider, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 0.4, constant: 0)
        let leftLayout = NSLayoutConstraint(item: slider, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 20)
        let rightLayout = NSLayoutConstraint(item: slider, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.8, constant: 0)
        self.view.addConstraints([topLayout,downLayout,leftLayout,rightLayout])
        
    }
    func setupLabelConstraint(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.blueColor()
        let centerX =  NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0)
        let centerY = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: 0)
        let width = NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.4, constant: 0)
        let height = NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.4, constant: 0)
        self.view.addConstraints([centerY,centerX,width,height])
    }
    func changelabelSize(){
        label.font = UIFont.systemFontOfSize(CGFloat(slider.value))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
