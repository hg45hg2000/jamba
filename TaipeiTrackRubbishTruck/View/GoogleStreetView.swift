//
//  GoogleStreetView.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/6/10.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import GoogleMaps
protocol GoogleStreetViewDelegate:class {
    func dismissForGoogleStreetView(sender: GoogleStreetView)
}

let  mainscreen = UIScreen.mainScreen().bounds

class GoogleStreetView: GMSPanoramaView {

    weak var delegates: GoogleStreetViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let dissmissButtom = UIButton(frame: CGRect(x: mainscreen.width/2, y: mainscreen.height/2, width: 50, height: 50))
        dissmissButtom.tintColor = UIColor.blueColor()
        dissmissButtom.setTitle("X", forState: UIControlState())
        dissmissButtom.addTarget(self, action: #selector(GoogleStreetView.dismissView), forControlEvents: .TouchUpInside)
        self.addSubview(dissmissButtom)
    }
    
  

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  dismissView(){
        self.delegates?.dismissForGoogleStreetView(self)
        print("tragler", terminator: "")
    }
}
