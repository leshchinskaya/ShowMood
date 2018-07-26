//
//  Welcome2ViewController.swift
//  ShowMood
//
//  Created by Marie on 21.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class Welcome2ViewController: UIViewController {
    
    // MARK: - Properties
    
    var accessToken = ""
    var right = 0, left = 0
    
    // MARK: - IBActions
    
    @IBAction func clearButton() {
        let storage : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in storage.cookies  as! [HTTPCookie]{
            storage.deleteCookie(cookie)
        }
        print ("clearButton")
        let loginAndChangeMoodVC = LoginAndChangeMood2ViewController(nibName: "LoginAndChangeMood2ViewController", bundle: nil)
        self.navigationController?.pushViewController(loginAndChangeMoodVC, animated: true)
    }
    
    // MARK: - BaseClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a background view
        assignbackground()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                do {
                let loginAndChangeMoodVC = LoginAndChangeMood2ViewController(nibName: "LoginAndChangeMood2ViewController", bundle: nil)
                self.navigationController?.pushViewController(loginAndChangeMoodVC, animated: true)
                print("Swiped left")
            }
            default:
                break
            }
        }
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
    
    // MARK: - Internal Methods
    
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
