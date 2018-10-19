//
//  UIImageView + Extension.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 01/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import SDWebImage
extension UIImageView
{
    func loadImage(id:Int, tag: Int)
    {
        let imageURL : URL = URL(string:GET_IMAGES_URL+"\(id)/" + "\(tag).jpg")!
        self.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "launchImages"), completed: { (image, error, cacheType, url) -> Void in
            if ((error) != nil) {
                self.image = #imageLiteral(resourceName: "noImageToPreview")
            } else {
                self.image = image
            }
        })
    }
    func loadImageWith(url:String)
    {
        let imageURL : URL = URL(string:SERVER_URL + url)!
        self.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "launchImages"), completed: { (image, error, cacheType, url) -> Void in
            if ((error) != nil) {
                self.image = #imageLiteral(resourceName: "noImageToPreview")
            } else {
                self.image = image
            }
        })
    }
}