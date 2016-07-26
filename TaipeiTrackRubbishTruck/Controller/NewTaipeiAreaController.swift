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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
    }
    
    func getData(){
        getTheTrushData { (json) in
            if let json  = json {
            let jsons = JSON(json)
            print(jsons["result"]["records"])
            let records = jsons["result"]["records"].arrayObject
            for record in (records)!{
                let rubbish = Rubbish(dictionary: record as? Dictionary<String,AnyObject>)
                self.rubbishs.insert(rubbish, atIndex: 0)
                }
            }
        }
//        dataDictionary?.creatDownLoadTask(Rubbish_Api, success: { (json, response) in
//            self.rubbishs = []
//            let jsons = json?["result"] as! Dictionary<String, AnyObject>
//            if let result = jsons as? Dictionary<String, AnyObject>{
//                let records = result["records"]
//                self.rubbishs.removeAll()
//                for  record in (records?.allObjects)! {
//                    let rubbish = Rubbish(dictionary:record as! Dictionary<String, AnyObject>)
//                    self.rubbishs.insert(rubbish, atIndex: 0)
//                    }
//                }
//                self.tableView.reloadData()
//                })
//            {
//            (error) in
//            print(error, terminator: "")
//        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "rubbishDetail"{
            if let   destViewController = segue.destinationViewController as? RubbishTruckController{
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
}
