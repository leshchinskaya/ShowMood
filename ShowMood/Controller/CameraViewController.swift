//
//  CameraViewController.swift
//  ShowMood
//
//  Created by Marie on 17.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit
import AVKit
import Vision
//import CoreML

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let labelPositive = UILabel()
    var positive = 0.0
    var left = 0, right = 0
    var accessToken = ""
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("CameraVC")
        assignbackground()
        
        //let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: VisualSentimentCNN().model) else { return }
        //guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedRequest, err) in
            print(finishedRequest.results)
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            
            guard let firstObserve = results.first else { return }
            self.positive = Double(firstObserve.confidence * 100)
            print("id= ", firstObserve.identifier, "conf= ", firstObserve.confidence)
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    @IBAction func stopCameraButton() {
        self.captureSession.stopRunning()
        print("\n\n", self.positive)
        self.diap()
        self.performSegue(withIdentifier: "showId", sender: nil)
    }
    
    func diap() {
        right = Int(positive + 10)
        left = Int(positive - 10)
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
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showId") {
            //let navigation = UINavigationController()
            //navigation.isNavigationBarHidden = true
            print("showId")
            let showVC = segue.destination as! ShowImagesCollectionViewController
            showVC.right = right
            showVC.left = left
            showVC.accessToken = accessToken
            //showVC.accessToken = accessToken
            //navigation.pushViewController(showVC, animated: true)
            
        }
    }
    
}
