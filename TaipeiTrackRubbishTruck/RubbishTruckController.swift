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
private struct RefreshTime{
    static let oneSencondTime :Double = 1
    static let threeMinTime : Double = 180
}

class RubbishTruckController: BaseViewController{

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = CustomRefresh(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

    var threeminsTimer = NSTimer()
    var oneSecondTimer = NSTimer()
    var Count = 0
    var selectedIndex = Int()
    let customInteractionController = CustomInteractionController()
    let popAnimation = PopAnimation()
    let tapeiservers = TapieiDataServers.sharedInstance
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        spinnerAdd()
        self.title = areaArray [selectedIndex]
        threeMinsToReloadData()
    }
    
    @IBAction func upDate(sender: UIBarButtonItem) {
        updateRubbish()
    }
    private func updateRubbish(){
        getData {
            if self.filterRubbishs.count == 0 {
                self.alertController("抱歉現在\(self.title!)沒有資料", message: "", cancelButton: "OK", style: .Alert)
            }else{
                self.alertController("更新已經完成", message: " 總共有 \(self.filterRubbishs.count) 筆", cancelButton: "Ok",style:.Alert)
            }
        }
    }
    func spinnerAdd(){
            refreshControl.addTarget(self, action: #selector(RubbishTruckController.pullTorefreah), forControlEvents: .ValueChanged)
            refreshControl.setuptableView(tableView)
            tableView.addSubview(refreshControl)
            spinner.hidesWhenStopped = true
            spinner.center = view.center
            view.addSubview(spinner)
    }
    
    func threeMinsToReloadData(){
        
            oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(RefreshTime.oneSencondTime, target: self, selector: #selector(RubbishTruckController.oneSecondupdateTime), userInfo: self, repeats: true)
            threeminsTimer  = NSTimer.scheduledTimerWithTimeInterval(RefreshTime.threeMinTime, target: self, selector: #selector(RubbishTruckController.pullTorefreah), userInfo: nil, repeats: true)
    }
    
    func oneSecondupdateTime(){
            Count = Count + 1
            tableView.reloadData()
    }
    func getData(completion:()->Void){
        
        let waitingView = ActivityIndicator(frame: self.view.frame)
        self.view.addSubview(waitingView)
        
        tapeiservers.getTheTrushData { [unowned self]json,error in
            if let json = json {
                self.rubbishs.removeAll(keepCapacity: true)
                for record in json{
                    let rubbish = Rubbish(dictionary: record )
                    self.rubbishs.insert(rubbish, atIndex: 0)
                }
                self.filterAndReloadTableView()
                completion()
               waitingView.removeFromSuperview()
            }
        }
    }
    func pullTorefreah(){
        tapeiservers.getTheTrushData {[unowned self] json,error in
            if let json = json {
                self.rubbishs.removeAll(keepCapacity: true)
                for record in json{
                    let rubbish = Rubbish(dictionary: record )
                    self.rubbishs.insert(rubbish, atIndex: 0)
                }
                    self.filterAndReloadTableView()
            }
        }
    }
    private func filterAndReloadTableView(){
        self.filterContentForArea(self.areaArray[self.selectedIndex])
        self.Count = 0
        self.tableView.reloadData()
    }
    // MARK: scrollView
    func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshControl.scrollViewDidScroll(scrollView)
    }
}

extension RubbishTruckController:UITableViewDelegate,UITableViewDataSource,RubbishTableCellDelegate
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  filterRubbishs.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rubbish = filterRubbishs[(indexPath as NSIndexPath).row]
        if  let cell = tableView.dequeueReusableCellWithIdentifier(Cell.rubbishCell, forIndexPath: indexPath ) as? RubbishTableViewCell {
            cell.configureCell(rubbish)
            cell.updateTime.text  = String(Count) + "秒前更新"
            if cell.buttondelegate == nil{
                cell.buttondelegate = self
            }
            
            return cell
        }
        else{
            return RubbishTableViewCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let googleViewController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerID.googleMapView)as! GoogleMapViewController
        googleViewController.selectRubbish = filterRubbishs[indexPath.row]
        self.navigationController?.pushViewController(googleViewController, animated: true)
    }
    func RubbishCelldidselected(RubbishCell: RubbishTableViewCell) {
        showAlertForRow(tableView.indexPathForCell(RubbishCell)!.row)
        let indexPath = NSIndexPath(forRow: tableView.indexPathForCell(RubbishCell)!.row, inSection: 0)
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
        tableView.endUpdates()
    }
}
extension RubbishTruckController:UINavigationControllerDelegate{
    func  navigationController(navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push{
            customInteractionController.attchToViewController(toVC, tableView: tableView)
        }
        return popAnimation
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }
}
