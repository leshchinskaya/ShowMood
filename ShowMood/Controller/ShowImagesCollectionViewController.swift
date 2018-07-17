//
//  ShowImagesCollectionViewController.swift
//  ShowMood
//
//  Created by Marie on 16.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ShowImagesCollectionViewController: UICollectionViewController {
    
    var accessToken = ""
    var right = 0, left = 0
    
    private var photoDictionaries = [AnyObject]()
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
        
        assignbackground()
        
        print (left, "..", right, " / accessToken = ", accessToken)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.

        //configure the collection view
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
                    
                    self.photoDictionaries = responseDictionary["data"] as! [AnyObject]
                    
                    for result in self.photoDictionaries {
                        let likes = result.value(forKeyPath: "likes.count") as! Int
                        let comment = result.value(forKeyPath: "comments.count") as! Int
                        let obj = ["comments": String(comment), "likes": String(likes)]
                        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photoDictionaries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.imagesPhotoCell, for: indexPath) as! ImagesCollectionViewCell

        let photoDictionary = photoDictionaries[indexPath.item]
        cell.photo = photoDictionary
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
