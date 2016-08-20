//
//  CustomInteractionController.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/19.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class CustomInteractionController: UIPercentDrivenInteractiveTransition {
    
    var navigationController : UINavigationController!
    var shouldCompleteTransition =  false
    var transitionInProgress = false
    var completionSeed : CGFloat{
        return 1 - percentComplete
    }
    func attchToViewController(viewController:UIViewController,tableView:UITableView?){
        navigationController = viewController.navigationController
        setupGestureRecognizer(viewController.view, tableView: tableView)
    }
    func setupGestureRecognizer(view:UIView,tableView:UITableView?){
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action:#selector(CustomInteractionController.handlePanGesture)))
        tableView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CustomInteractionController.handlePanGesture)))
        
    }
    func handlePanGesture(gestureRecognizer:UIPanGestureRecognizer){
        let viewTransition = gestureRecognizer.translationInView(gestureRecognizer.view)
        
        switch gestureRecognizer.state {
        case .Began:
            transitionInProgress = true
            navigationController.popViewControllerAnimated(true)
        case .Changed:
            let const = CGFloat (fminf(fmaxf(Float(viewTransition.x / 200.0),0.0),1.0))
            shouldCompleteTransition = const > 0.5
           updateInteractiveTransition(const)
        case .Cancelled,.Ended:
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .Cancelled{
                cancelInteractiveTransition()
            }
            else{
                finishInteractiveTransition()
            }
        default:
            print(" fuck you  swift", terminator: "")
        }
    }
}
