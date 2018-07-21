//
//  ImagesCollectionViewCell.swift
//  ShowMood
//
//  Created by Marie on 17.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: AnyObject! {
        didSet {
            InstagramData.imageForPhoto(photoDictionary: photo, size: "thumbnail") { (image) -> Void in
                self.imageView.image = image
            }
        }
    }
}
