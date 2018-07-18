//
//  ShowImagesCollectionViewController.swift
//  ShowMood
//
//  Created by Marie on 16.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreML

private let reuseIdentifier = "Cell"

class ShowImagesCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var accessToken = ""
    var right = 0, left = 0
    var currentPositive = 0.0
    
    private let trainedImageSize = CGSize(width: 227, height: 227)
    
    private var photoDictionaries = [AnyObject]()
    private var photoDictionariesFiltered = [AnyObject]()
    private var img = [AnyObject]()
    var data: [[String: String?]] = []
    
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    struct Storyboard {
        static let imagesPhotoCell = "ImagesPhotoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a background view
        assignbackground()
        
        print (left, "..", right, " / accessToken = ", accessToken)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Configure the collection view
        let width = (collectionView!.frame.size.width - leftAndRightPaddings) / numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
        
        fetchPhotos()
    }
    
    // MARK: - Helper Methods
    func fetchPhotos() {
        let session = URLSession.shared

        let urlSring = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)"
        guard let url = URL(string: urlSring) else { return }
        
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { (localFile, response, error) in
            if error == nil {
                let data = try! Data(contentsOf: localFile!)
                
                do {
                    let responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    
                    self.photoDictionaries = responseDictionary["data"] as! [UIImage]
                    
                    for result in self.photoDictionaries {
                        let likes = result.value(forKeyPath: "likes.count") as! Int
                        let comment = result.value(forKeyPath: "comments.count") as! Int
                        let obj = ["comments": String(comment), "likes": String(likes)]
                        
                        let image = result.value(forKeyPath: "images.thumbnail.url") as! String
                        print(image)
                        
                        let urlImage = URL(string: image)
                        let data = try? Data(contentsOf: urlImage!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        let currentImage = UIImage(data: data!)
                        
                        self.predict(image: currentImage!)
                        
                        if (Int(self.currentPositive) >= self.left && Int(self.currentPositive) <= self.right) {
                            self.photoDictionariesFiltered.append(result)
                        }
                    
                        self.data.append(obj)
                    }
                    
                } catch let error {
                    print (error)
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        task.resume()
    }
    
    // Add a background view
    func assignbackground(){
        let background = UIImage(named: "fon")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        self.collectionView?.backgroundView = imageView
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return self.photoDictionaries.count
        return self.photoDictionariesFiltered.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.imagesPhotoCell, for: indexPath) as! ImagesCollectionViewCell

        //let photoDictionary = photoDictionaries[indexPath.item]
        let photoDictionary = photoDictionariesFiltered[indexPath.item]

        cell.photo = photoDictionary
        return cell
    }
    
    func predict(image: UIImage) {
        let model = VisualSentimentCNN()
        
        do {
            if let resizedImage = resize(image: image, newSize: trainedImageSize), let pixelBuffer = resizedImage.toCVPixelBuffer() {
                let prediction = try model.prediction(data: pixelBuffer)
                print ("prediction value:", prediction.prob)
                self.currentPositive = prediction.prob["Positive"] ?? 0.0
                self.currentPositive = currentPositive * 100
                print(currentPositive)
            }
        } catch {
            print("Error while doing predictions: \(error)")
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let photo = self.photoDictionaries[indexPath.row] as! NSDictionary
        
        let photo = self.photoDictionariesFiltered[indexPath.row] as! NSDictionary
        
        let viewController = DetailImageViewController()
        viewController.modalPresentationStyle = UIModalPresentationStyle.custom
        
        //viewController.transitioningDelegate = self
        viewController.photo = photo
        
        self.present(viewController, animated: false, completion: nil)
    }

}

// MARK: - UISearchBarDelegate
extension ShowImagesCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            fetchPhotos()
        }
    }
}


// MARK: - UIViewControllerTransitioningDelegate
extension ShowImagesCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentDetailTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissDetailTransition()
    }
}

// MARK: UIImage vs CVPixelBuffer
extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

