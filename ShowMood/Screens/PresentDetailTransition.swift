//
//  PresentDetailTransition.swift
//  ShowMood
//
//  Created by Marie on 17.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class PresentDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let detail = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        detail.view.alpha = 0.0
        
        var frame = containerView.bounds
        frame.origin.y += 20
        frame.size.height -= 20
        detail.view.frame = frame
        containerView.addSubview(detail.view)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void  in
            detail.view.alpha = 1.0
        }) { (finished: Bool) -> Void in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
}
