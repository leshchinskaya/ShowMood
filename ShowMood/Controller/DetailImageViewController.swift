//
//  DetailImageViewController.swift
//  ShowMood
//
//  Created by Marie on 17.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {
    
    var photo: NSDictionary?
    var imageView: UIImageView?
    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView = UIImageView(frame: CGRect(x: 0, y: -320, width: self.view.bounds.size.width, height: self.view.bounds.size.width))
        
        imageView?.layer.cornerRadius = 20
        imageView?.clipsToBounds = true
        
        self.view.addSubview(imageView!)
        
        
        if let photoDictionary = photo {
            InstagramData.imageForPhoto(photoDictionary: photoDictionary, size: "standard_resolution", completion:  {(image) -> Void in
                self.imageView!.image = image
            })
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let snap = UISnapBehavior(item: self.imageView!, snapTo: self.view.center)
        //let snap = UIGravityBehavior(items: [self.imageView!])
        self.animator?.addBehavior(snap)
    }
    
    @objc func close() {
        self.animator?.removeAllBehaviors()
        
        let rect = self.view.bounds
        let snap = UISnapBehavior(item: self.imageView!, snapTo: CGPoint(x: rect.midX, y: rect.maxY + 100 ))
        
        self.animator?.addBehavior(snap)
        
        self.dismiss(animated: true, completion: nil)
    }
}
