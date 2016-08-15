//
//  NewTaipeiAreaController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/16.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit


class NewTaipeiAreaController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var selectedIndex :Int = 0
    let tapeiservers = TapieiDataServers.sharedInstance
    var scrollOrientation = UIImageOrientation(rawValue: 0)
    var lastPons = CGPoint()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "新北市垃圾車"
               
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animationTable()
    }
    @IBAction func updateDate(sender: UIButton) {
        getData()
        alertController("更新已經完成", message: " 總共有 \(self.rubbishs.count) 筆", cancelButton: "Ok",style:.Alert)
        
    }
    
    func getData(){
        
        tapeiservers.getTheTrushData { (json) in
            if let json  = json {
                let jsons = JSON(json)
                let records = jsons["result"]["records"].arrayObject
                self.rubbishs.removeAll(keepCapacity: true)
                for record in (records)!{
                    let rubbish = Rubbish(dictionary: record as? Dictionary<String,AnyObject>)
                    self.rubbishs.insert(rubbish, atIndex: 0)
                }
                
            }
        
        }
        
    }
    func animationTable(){
    
        self.tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        for i in cells{
            let cell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableViewHeight)
        }
        var index : Double = 0
        for a in cells {
            let cell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * index, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                
                }, completion: nil)
                index += 1
            }
        getData()

        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "rubbishDetail"{
            if let   destViewController = segue.destinationViewController as?RubbishTruckController
            {
                
                selectedIndex  = ((self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row)!
                filterContentForArea(areaArray[selectedIndex])
                destViewController.filterRubbishs = filterRubbishs
                destViewController.selectedIndex = selectedIndex
            }
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = areaArray[(indexPath as NSIndexPath).row]
        return cell!

    }
   
   
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
            switch scrollView.panGestureRecognizer.state{
            case  .Changed :
            let velocity = scrollView.panGestureRecognizer.translationInView(self.view?.superview).y
            if  velocity < 0  {
                navigationController?.setNavigationBarHidden(true, animated: true)
            }
            else{
                navigationController?.setNavigationBarHidden(false, animated: true)
            }
            default:break
        }
    }
}
