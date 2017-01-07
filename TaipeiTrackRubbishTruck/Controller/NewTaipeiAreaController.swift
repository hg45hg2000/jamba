//
//  NewTaipeiAreaController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/16.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit


class NewTaipeiAreaController: BaseViewController {
    
    
    var selectedIndex :Int = 0
    let tapeiservers = TapieiDataServers.sharedInstance
    var scrollOrientation = UIImageOrientation(rawValue: 0)
    var lastPons = CGPoint()
    
    
    @IBOutlet weak var tableView: UITableView!
    //MARK : Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "新北市垃圾車"
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animationTable()
    }
    
    func animationTable(){
        getData()
        tableViewAnimation(tableView)
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
    // MARK: ScrollView
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
    // MARK: RequestData
    func getData(){
        tapeiservers.getTheTrushData { [unowned self] json,error in
            if let json  = json {
                self.rubbishs.removeAll(keepCapacity: true)
                for record in json{
                    let rubbish = Rubbish(dictionary: record)
                    self.rubbishs.insert(rubbish, atIndex: 0)
                }
                
            }
        }
    }
    func updateSingleTableViewCell(){
        filterArea(areaArray) { index in
            let indexPathArray = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPathArray], withRowAnimation: .Fade)
        }
    }
}
extension NewTaipeiAreaController:UITableViewDelegate,UITableViewDataSource {
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!NewTaipeiCell
        cell.areaLable.text = areaArray[indexPath.row]
        cell.NotificationView.hidden = true
        filterArea(areaArray) {  index in
            if (indexPath.row == index){
                cell.NotificationView.hidden = false
            }
        }
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        
    }
}
