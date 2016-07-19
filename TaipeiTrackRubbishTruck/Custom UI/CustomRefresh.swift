//
//  CustomRefresh.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/6/18.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class CustomRefresh: UIRefreshControl,UIScrollViewDelegate {

    var compass_background = UIImageView()
    var compass_spinner = UIImageView()
    var refreshColorView = UIView()
    var refreshLoadingView = UIView()
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRefreshControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setuptableView(tableview:UITableView) {
        self.tableView = tableview
    }
    
    
    internal func scrollViewDidScroll(scrollView: UIScrollView) {
    
        // Get the current size of the refresh controller
        var refreshBounds = self.bounds;
        
        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -self.frame.origin.y);
        
        // Half the width of the table
        let midX = self.tableView.frame.size.width / 2.0;
        
        // Calculate the width and height of our graphics
        let compassHeight = self.compass_background.bounds.size.height;
        let compassHeightHalf = compassHeight / 2.0;
        
        let compassWidth = self.compass_background.bounds.size.width;
        let compassWidthHalf = compassWidth / 2.0;
        
        let spinnerHeight = self.compass_spinner.bounds.size.height;
        let spinnerHeightHalf = spinnerHeight / 2.0;
        
        let spinnerWidth = self.compass_spinner.bounds.size.width;
        let spinnerWidthHalf = spinnerWidth / 2.0;
        
        // Calculate the pull ratio, between 0.0-1.0 buz 100 pulldistance over 1
        let pullRatio = min( max(pullDistance, 0.0), 100.0)/100.0 ;
        
        // Set the Y coord of the graphics, based on pull distance
        let compassY = pullDistance / 2.0 - compassHeightHalf;
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
        // Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
        var spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
        
        // When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            self.isRefreshIconsOverlap = true;
        }
        
        // If the graphics have overlapped or we are refreshing, keep them together
        if (self.isRefreshIconsOverlap || self.refreshing) {
            compassX = midX - compassWidthHalf;
            spinnerX = midX - spinnerWidthHalf;
        }
        
        // Set the graphic's frames
        var compassFrame = self.compass_background.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = self.compass_spinner.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        self.compass_background.frame = compassFrame;
        self.compass_spinner.frame = spinnerFrame;
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        self.refreshColorView.frame = refreshBounds;
        self.refreshLoadingView.frame = refreshBounds;
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshing && !self.isRefreshAnimating) {
            self.animatRefreshView()
        }
        
       
    }
    //refreshControll
    func setupRefreshControl(){
        
        refreshLoadingView = UIView(frame: self.bounds)
        refreshLoadingView.backgroundColor = UIColor.clearColor()
        
        refreshColorView = UIView(frame:  self.bounds)
        refreshColorView.backgroundColor = UIColor.clearColor()
        refreshColorView.alpha = 0.30
        
        compass_background = UIImageView(image: UIImage(named: "compass_background.png"))
        compass_spinner = UIImageView(image: UIImage(named: "compass_spinner.png"))
        
        refreshLoadingView.addSubview(compass_background)
        refreshLoadingView.addSubview(compass_spinner)
        
        refreshLoadingView.clipsToBounds = true
        
        // Hide original spinner icon
        self.tintColor = UIColor.clearColor()
        
        self.addSubview(refreshColorView)
        self.addSubview(refreshLoadingView)
        
        self.isRefreshIconsOverlap = false
        self.isRefreshAnimating = false
        
        self.addTarget(self, action: #selector(CustomRefresh.refresh), forControlEvents: .ValueChanged)
        
    }
    func refresh(){
        
        var delayInSeconds = 3.0;
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            // When done requesting/reloading/processing invoke endRefreshing, to close the control
            self.endRefreshing()
        }
    }
    func  resetAnimation() {
        self.isRefreshAnimating = false
        self.isRefreshIconsOverlap = false
        self.refreshColorView.backgroundColor = UIColor.clearColor()
    }
    func animatRefreshView(){
        var colorArray = [UIColor.redColor(),UIColor.orangeColor(),UIColor.yellowColor(),UIColor.cyanColor()]
        struct ColorIndex {
            static var colorIndex = 0
        }
        self.isRefreshAnimating = true
        
        UIView.animateWithDuration(Double(0.3), delay: Double(0.0), options: .CurveLinear, animations: {
            self.compass_spinner.transform = CGAffineTransformRotate(self.compass_spinner.transform, CGFloat(M_PI_2))
            self.refreshColorView.backgroundColor = colorArray[ColorIndex.colorIndex]
            ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            
        }) { finished in
            if self.refreshing {
                self.animatRefreshView()
            }
            else{
                self.resetAnimation()
            }
        }
    }
    
    
}


