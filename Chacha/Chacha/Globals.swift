//
//  Globals.swift
//  Chacha
//
//  Created by Daniel Jones on 2/24/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import UIKit

//Custom colors
let ChachaTeal = UIColor(rgba: "#5ABBB6")
let iLikeyPink =  UIColor(rgba: "#E91E63")
let iLikeyPinkLight = UIColor(rgba: "#FA6FEB")
let iLikeyPinkDark =  UIColor(rgba: "#cc0066")
let iLikeyBlue =  UIColor(rgba: "#4e92e0")
let iLikeyGrayBorders =  UIColor(rgba: "#8c8c8c")
let iLikeyGrayControls =  UIColor(rgba: "#757575")
let iLikeyGrayBackground =  UIColor(rgba: "#ebebeb")
let iLikeyGrayMercury =  UIColor(rgba: "#F8F8F8")
let iLikeyGrayMedium =  UIColor(rgba: "#4A4A4A")
let iLikeyGrayDark =  UIColor(rgba: "#cdcdcd")
let iLikeyWhite =  UIColor(rgba: "#ffffff")
let iLikeyFacebookBlue = UIColor(rgba: "#5e9de6")
let iLikeyTwitterBlue = UIColor(rgba: "#4a90e0")
let iLikeyClearColor = UIColor(rgba: "#000000")

//UI effects
func applyShadow(view:UIView) {
    view.layer.shadowRadius = 2.5
    view.layer.shadowOffset = CGSizeMake(0, 1)
    view.layer.shadowColor = UIColor(rgba: "#555").CGColor
    view.layer.shadowOpacity = 2.0
}

func applyBorder(view:UIView) {
    view.layer.borderColor = UIColor(rgba: "#BBB").CGColor
    view.layer.borderWidth = 0.5
}

//Alert
//func iLikeyAlert(vc:UIViewController, title:String, message:String?, completion: (() -> Void)?) {
//    UIAlertController.showAlertInViewController(vc, withTitle:title, message: message, cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonTitles: nil) { (controller, action, buttonIndex) in
//        completion?()
//    }


