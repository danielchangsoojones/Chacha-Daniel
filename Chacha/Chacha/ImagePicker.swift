//
//  ImagePicker.swift
//  Chacha
//
//  Created by Daniel Jones on 3/2/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import UIKit

class ImagePicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView : UIImageView
    let viewController: UIViewController
    
    init (viewController: UIViewController, image: UIImageView) {
        self.viewController = viewController
        self.imageView = image
        super.init()
        setImagePickerDelegate()
    }
    
    func setImagePickerDelegate() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imgPicker.allowsEditing = true
        viewController.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    //Mark: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        
    }
    
}