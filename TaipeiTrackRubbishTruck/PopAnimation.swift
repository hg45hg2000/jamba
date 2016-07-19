//
//  PopAnimation.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/19.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit

class PopAnimation: NSObject,UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewKey)
        let containerView = transitionContext.containerView()
        
        transitionContext.containerView()!.addSubview(toVC!.view)
        transitionContext.containerView()!.addSubview(fromVC!.view)
        toVC?.view.transform = CGAffineTransformMakeTranslation(-100, 0)
        toVC?.view.alpha = 0.5
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromVC?.view.transform = CGAffineTransformMakeTranslation((fromVC?.view.frame)!.width, 0)
            toVC?.view.alpha = 1.0
            toVC?.view.transform = CGAffineTransformIdentity
            }) { (Bool) in
                fromVC?.view.transform = CGAffineTransformIdentity
                toVC?.view.transform = CGAffineTransformIdentity
        }
        if transitionContext.transitionWasCancelled(){
            
        }
        transitionContext.completeTransition(transitionContext.transitionWasCancelled())
    }
}
