//
//  Photo.swift
//  Chacha
//
//  Created by Daniel Jones on 3/1/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class Photo {
    
    class func allPhotos() -> [Photo] {
        var photos = [Photo]()
        if let URL = NSBundle.mainBundle().URLForResource("Photos", withExtension: "plist") {
            if let photosFromPlist = NSArray(contentsOfURL: URL) {
                for dictionary in photosFromPlist {
                    let photo = Photo(dictionary: dictionary as! NSDictionary)
                    photos.append(photo)
                }
            }
        }
        return photos
    }
    
    var caption: String
    var comment: String
    var image: UIImage
    var profileImage: UIImage = UIImage(named: "Pattern")!
    var fullName: String = "Amanda Towns"
    var username: String = "@pandaLover"
    var question: String = "What is the meaning of Life and I dont really care heyyooasdfkjsdlfsjdf;sajdfjsl;dfjklsadjflkjas;dlfjls;akdjf;lsjdfkljsadkl;fj;sladjflksjdfl;ajsdlfkjs?"
    
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let caption = dictionary["Caption"] as? String
        let comment = dictionary["Comment"] as? String
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(caption: caption!, comment: comment!, image: image!)
    }
    
}
