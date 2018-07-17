//
//  InstagramData.swift
//  ShowMood
//
//  Created by Marie on 17.07.2018.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit
import SAMCache

class InstagramData {
    
    static func imageForPhoto (photoDictionary: AnyObject, size: String, completion: @escaping (_ image: UIImage) ->  Void) {
        
        let photoID = photoDictionary["id"] as! String
        let key = "\(photoID)-\(size)"
        
        if let image = SAMCache.shared().image(forKey: key) {
            completion(image)
        } else {
            let urlString = photoDictionary.value(forKeyPath: "images.\(size).url") as! String
            let url = URL(string: urlString)
            
            let session = URLSession.shared
            let request = URLRequest(url: url!)
            let task = session.downloadTask(with: request) { (localFile, response, error) in
                if error == nil {
                    let data = try! Data(contentsOf: localFile!)
                    let image = UIImage (data: data)
                    
                    SAMCache.shared().setImage(image, forKey: key)
                    
                    DispatchQueue.main.async {
                        completion(image!)
                    }
                }
            }
            task.resume()
        }
    }
    
}
