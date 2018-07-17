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

        assignbackground()
        // Add a background view
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fon.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignbackground(){
        let background = UIImage(named: "fon")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
