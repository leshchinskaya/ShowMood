//
//  LoginAndChangeMood2ViewController.swift
//  ShowMood
//
//  Created by Marie on 21.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit
import KeychainSwift
import SystemConfiguration

class LoginAndChangeMood2ViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - Constants
    
    let loginWebView: UIWebView = UIWebView (frame: CGRect (x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let keychain = KeychainSwift()
    
    // MARK: - Properties
    
    var accessToken = ""
    var right = 0, left = 0
    var internetSuccess = false
    
    // MARK: - IBActions
    
    @IBAction func verySadButton() {
        left = 0
        right = 20
        print(left, "..", right)
        perfomValues()
    }
    
    @IBAction func sadButton() {
        left = 21
        right = 40
        print(left, "..", right)
        perfomValues()
    }
    
    @IBAction func neitralButton() {
        left = 41
        right = 60
        print(left, "..", right)
        perfomValues()
    }
    
    @IBAction func happyButton() {
        left = 61
        right = 80
        print(left, "..", right)
        perfomValues()
    }
    
    @IBAction func veryHappyButton() {
        left = 81
        right = 100
        print(left, "..", right)
        perfomValues()
    }
    
    @IBAction func openCameraButton() {
        let camera2VC = Camera2ViewController(nibName: "Camera2ViewController", bundle: nil)
        camera2VC.accessToken = accessToken
        self.navigationController?.pushViewController(camera2VC, animated: true)
    }
    
    // MARK: - BaseClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let url = URL(string: "https://www.google.com")!
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                
                if error != nil {
                    self.navigationItem.title = "internet - failed"
                    print("internet not available!")
                }
                else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("internet ok")
                        self.internetSuccess = true
                    }
                    print("statusCode: \(httpResponse.statusCode)")
                }
                
            }
            task.resume()
        }
        
        loginWebView.scrollView.contentInsetAdjustmentBehavior = .automatic
        
        assignbackground()
        
        loginWebView.delegate = self
        self.view.addSubview(loginWebView)
        unSignedRequest()
    }
    
    // MARK: - Internal methods
    
    /*
     %-positive
     0-20 - very sad
     21-40 - sad
     41-60 - neitral
     61-80 - happy
     81-100 - very happy
     */
    
    func perfomValues() {
        let showImages3VC = ShowImages3ViewController(nibName: "ShowImages3ViewController", bundle: nil)
        showImages3VC.left = left
        showImages3VC.right = right
        showImages3VC.accessToken = accessToken
        self.navigationController?.pushViewController(showImages3VC, animated: true)
    }
    
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
        keychain.set(authToken, forKey: "token")
        accessToken = keychain.get("token") ?? ""

        if (authToken == "") {
            navigationItem.title = "Error with Auth"
            accessToken = INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN
        }
        print("Instagram authentication token ==", accessToken)
        
        loginWebView.stopLoading()
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
        let check = checkRequestForCallbackURL(request: request)
        return check
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        navigationItem.title = Settings().waitString
        loginWebView.backgroundColor = UIColor(patternImage: Settings().background!)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (internetSuccess) { navigationItem.title = "" }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
}
