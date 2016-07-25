//
//  RubbishTruck.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/14.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

struct Cell {
    
    static let rubbishCell = "rubbish"
}

class RubbishTruckController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = CustomRefresh(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

   
    var threeTimer = NSTimer()
    var oneSecondTimer = NSTimer()
    var Count = 0
    var selectedIndex = Int()
    var menuTransitionManager = MenuTransitionManager()
    let customInteractionController = CustomInteractionController()
    let popAnimation = PopAnimation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerAdd()
        self.title = areaArray [selectedIndex]
        threeMinsToReloadData()
        
    }
    
    func spinnerAdd(){
        refreshControl.addTarget(self, action: #selector(RubbishTruckController.getData), forControlEvents: .ValueChanged)
        refreshControl.setuptableView(tableView)
        tableView.addSubview(refreshControl)
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
    }
    
    func threeMinsToReloadData(){
        oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RubbishTruckController.oneSecondupdateTime), userInfo: self, repeats: true)
        threeTimer  = NSTimer.scheduledTimerWithTimeInterval(180, target: self, selector: #selector(RubbishTruckController.getData), userInfo: nil, repeats: true)
    }
    
    func oneSecondupdateTime(){
        Count = Count + 1
        tableView.reloadData()
    }
    // tableView 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  filterRubbishs.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rubbish = filterRubbishs[(indexPath as NSIndexPath).row]
        if  let cell = tableView.dequeueReusableCellWithIdentifier(Cell.rubbishCell) as? RubbishTableViewCell {
            cell.configureCell(rubbish)
            cell.updateTime.text  = String(Count) + "秒前更新"
            return cell
        }
        else{
            return RubbishTableViewCell()
        }

    }
    //Navigation
    
    func  navigationController(navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push{
           customInteractionController.attchToViewController(toVC, tableView: tableView)
        }
        return popAnimation
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }
    
    func getData(){
//        getTheTrushData { (Json) in
//            print(JSON)
//        }
        
//        dataDictionary?.creatDownLoadTask(Rubbish_Api, success: { (json, response) in
//            self.rubbishs = []
//            let jsons = json?["result"] as! Dictionary<String, AnyObject>
//            if let result = jsons as? Dictionary<String, AnyObject>{
//                let records = result["records"]
//                self.rubbishs.removeAll()
//                for  record in (records?.allObjects)! {
//                    let rubbish = Rubbish(dictionary:record as! Dictionary<String, AnyObject>)
//                    self.rubbishs.insert(rubbish, atIndex: 0)
//                }
//            }
//            self.filterContentForArea(self.areaArray[self.selectedIndex])
//            self.spinner.stopAnimating()
//            self.Count = 0
//            self.tableView.reloadData()
//            })
//        {
//            (error) in
//            print(error, terminator: "")
//        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshControl.scrollViewDidScroll(scrollView)
    }
    
}

