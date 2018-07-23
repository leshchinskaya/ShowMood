//
//  ImagesCollection2ViewCell.swift
//  ShowMood
//
//  Created by Marie on 21.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class ImagesCollection2ViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var positiveValueLabel: UILabel!
    
    var photo: AnyObject! {
        didSet {
            InstagramData.imageForPhoto(photoDictionary: photo, size: "thumbnail") { (image) -> Void in
                self.imageView.image = image
            }
        }
    }
    
    var label: String! {
        didSet {
            self.positiveValueLabel.text = label
        }
    }
}
