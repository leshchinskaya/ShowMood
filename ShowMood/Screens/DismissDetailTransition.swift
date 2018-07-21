//
//  DismissDetailTransition.swift
//  ShowMood
//
//  Created by Marie on 17.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class DismissDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let detail = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void  in
            detail.view.alpha = 0.0
        }) { (finished: Bool) -> Void in
            detail.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}
