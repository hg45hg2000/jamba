//
//  NotificationTableViewController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/9/27.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    static let  RefreshNewsFeedNotification = "RefreshNewsFeedNotification"
    let newStore = NewsStore.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.rowHeight  = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotificationTableViewController.receivedRefreshNewsFeedNotification(_:)), name:NotificationTableViewController.RefreshNewsFeedNotification , object: nil)
    }
    func receivedRefreshNewsFeedNotification(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
        
    }
    override func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newStore.items.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  NewItemCell(style:.Value1, reuseIdentifier: "Cell")
        let item = newStore.items[indexPath.row]
        cell.updateWithNewsItem(item)
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            newStore.removeItems(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

}

