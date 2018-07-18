//
//  WelcomeViewController.swift
//  ShowMood
//
//  Created by Marie on 16.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var accessToken = ""
    var right = 0, left = 0

    @IBAction func nextButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a background view
        assignbackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    // Add a background view
    func assignbackground(){
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Settings().background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }

}
