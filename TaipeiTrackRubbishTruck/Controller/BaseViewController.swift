//
//  BaseViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/17.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
protocol AreaRubbishDelegate :class{
    func getTheRubbishCellHaveDataIndex(index:Int)
}

class BaseViewController: UIViewController {
    
    var filterRubbishs = [Rubbish]()
    var rubbishs = [Rubbish]()
    var areaArray = ["淡水區","板橋區","新店區","石碇區","永和區","三重區","新莊區","中和區","樹林區","貢寮區","雙溪區","土城區","三芝區","汐止區"]
    var matchIndex = [index]
    
    weak var delegate:AreaRubbishDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func filterArea(filter:[String],completion:((Int))->Void){
        self.filterRubbishs = []
        for index in 0..<filter.count{
            filterRubbishs = rubbishs.filter({ (Rubbish) -> Bool in
                let locationMatch = Rubbish.location.rangeOfString(filter[index])
                if (locationMatch != nil) {
                    completion(index)
                    self.delegate?.getTheRubbishCellHaveDataIndex(index)
                    filterRubbishs.append(Rubbish)
                }
                return locationMatch != nil
            })
        }
    }

    func filterContentForArea(filter:String){
        self.filterRubbishs = []
        filterRubbishs = rubbishs.filter({ (Rubbish) -> Bool in
            let locationMatch = Rubbish.location.rangeOfString(filter)
            if (locationMatch != nil) {
                filterRubbishs.append(Rubbish)
            }
            return locationMatch != nil
        })
    }
   
    func alertController(title:String,message:String,cancelButton:String,style:UIAlertControllerStyle){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let canelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(canelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func showAlertForRow(row: Int) {
        let alert = UIAlertController(
            title: "BEHOLD",
            message: "Cell at row \(row) was tapped!",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Default, handler: { (test) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(
            alert,
            animated: true,
            completion: nil)
    }
    
}
