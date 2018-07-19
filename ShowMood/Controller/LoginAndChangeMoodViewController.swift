//
//  LoginAndChangeMoodViewController.swift
//  ShowMood
//
//  Created by Marie on 17.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginAndChageMoodViewController: UIViewController, UIWebViewDelegate {
    
    let loginWebView: UIWebView = UIWebView (frame: CGRect (x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var accessToken = ""
    var right = 0, left = 0
    
    let keychain = KeychainSwift()
    
    /*
     %-positive
     0-20 - very sad
     21-40 - sad
     41-60 - neitral
     61-80 - happy
     81-100 - very happy
     */
    
    @IBAction func verySadButton() {
        left = 0
        right = 20
        print(left, "..", right)
        performSegue(withIdentifier: "showIdentifier", sender: nil)
    }
    
    @IBAction func sadButton() {
        left = 21
        right = 40
        print(left, "..", right)
        performSegue(withIdentifier: "showIdentifier", sender: nil)
    }
    
    @IBAction func neitralButton() {
        left = 41
        right = 60
        print(left, "..", right)
        performSegue(withIdentifier: "showIdentifier", sender: nil)
    }
    
    @IBAction func happyButton() {
        left = 61
        right = 80
        print(left, "..", right)
        performSegue(withIdentifier: "showIdentifier", sender: nil)
    }
    
    @IBAction func veryHappyButton() {
        left = 81
        right = 100
        print(left, "..", right)
        performSegue(withIdentifier: "showIdentifier", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignbackground()
        
        loginWebView.delegate = self
        self.view.addSubview(loginWebView)
        unSignedRequest()
    }
    
    //MARK: - unSignedRequest
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        loginWebView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        accessToken = authToken
        if (authToken == "") {
            accessToken = "4625589.3e1a01f.47608692b7054008bba207b91370703a"
        }
        print("Instagram authentication token ==", accessToken)
        
        let welcomeVC = WelcomeViewController()
        welcomeVC.accessToken = accessToken
        
        loginWebView.isHidden = true
        
    }
    
    
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
    
    
    
    // MARK: - UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //loginIndicator.isHidden = false
        navigationItem.title = "Please, wait"
        loginWebView.backgroundColor = UIColor(patternImage: Settings().background!)
        //loginIndicator.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //loginIndicator.isHidden = true
        navigationItem.title = ""
        //loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    
    
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showIdentifier") {
            //let navigation = UINavigationController()
            //navigation.isNavigationBarHidden = true
            print("showIdentifier")
            let showVC = segue.destination as! ShowImagesCollectionViewController
            showVC.right = right
            showVC.left = left
            showVC.accessToken = accessToken
            //navigation.pushViewController(showVC, animated: true)

        } else if (segue.identifier == "cameraIdentifier") {
            print("cameraIdentifier")
            let cameraVC = segue.destination as! CameraViewController
            cameraVC.accessToken = accessToken
        }
     }
}

