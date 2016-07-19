//
//  BaseViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/17.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import iAd

class BaseViewController: UIViewController,ADBannerViewDelegate {
    
    var filterRubbishs = [Rubbish]()
    var rubbishs = [Rubbish]()
    var areaArray = ["淡水區","板橋區","新店區","中和區","石碇區","永和區","三重區","新莊區","中和區","樹林區","貢寮區","雙溪區"]
    var adView = ADBannerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        initialziAdView()
        
    }
    
    func filterContentForArea(_ filter:String){
        self.filterRubbishs = []
        filterRubbishs = rubbishs.filter({ (Rubbish) -> Bool in
            let locationMatch = Rubbish.location.rangeOfString(filter)
            if (locationMatch != nil) {
                filterRubbishs.append(Rubbish)
            }
            return locationMatch != nil
        })
    }
    func initialziAdView(){
        adView.frame  = CGRect(x: 0, y: self.view.frame.size.height - 100, width: 320, height: 50)
        adView.delegate = self
        adView.alpha = 0
        adView.delegate = self
        self.view.addSubview(adView)
    }
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        UIView.animateWithDuration(0.5) {
            self.adView.alpha = 1.0
        }
    }
//    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//        UIView.animateWithDuration(0.5) {
//            self.adView.alpha = 0.0
//        }
//    }
    
    
}
