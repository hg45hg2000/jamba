//
//  SildeSideMenu.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/8/17.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

public class SildeSideMenu: UIViewController,UITableViewDelegate,UITableViewDataSource {

    public var containView = UIView()
    public var mainViewController : UIViewController?{
        willSet{
            removeLastViewController(mainViewController)
        }
        didSet{
            addNewViewController(mainViewController)
        }
    }
    public var manuTableView = UITableView()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(mainViewController:UIViewController){
        self.init()
        self.mainViewController = mainViewController
        manuTableView.delegate = self
        manuTableView.dataSource = self
    }
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = UITableViewCell()
        cell.textLabel?.text = "yooooooo"
        return cell
    }
    
    
    func  removeLastViewController(viewController:UIViewController?) {
        if let views = viewController{
            views.willMoveToParentViewController(nil)
            views.view.removeFromSuperview()
            views.removeFromParentViewController()
        }
    }
    func  addNewViewController(viewController:UIViewController?) {
        if let views = viewController{
            addChildViewController(views)
            views.view.frame = containView.bounds
            containView.addSubview(views.view)
            views.didMoveToParentViewController(self)
        }
    }
}
