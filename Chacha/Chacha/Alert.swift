//
//  Alert.swift
//  Chacha
//
//  Created by Daniel Jones on 2/29/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import SCLAlertView

class Alert {
    
    init(title: String, subtitle: String, closeButtonTitle: String, type: SCLAlertViewStyle) {
        let alert = SCLAlertView()
        switch type {
        case .Success :
            alert.showSuccess(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Error :
            alert.showError(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Notice :
            alert.showNotice(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Warning :
            alert.showWarning(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Info :
            alert.showInfo(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Edit :
            alert.showEdit(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Wait :
            alert.showWait(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        }
    }
    
    init(title: String, subtitle: String, closeButtonTitle: String, additionalButtonTitle: String, type: SCLAlertViewStyle, buttonAction: () -> Void) {
        let alert = SCLAlertView()
        alert.addButton(additionalButtonTitle, action: buttonAction)
        switch type {
        case .Success :
            alert.showSuccess(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Error :
            alert.showError(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Notice :
            alert.showNotice(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Warning :
            alert.showWarning(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Info :
            alert.showInfo(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Edit :
           alert.showEdit(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        case .Wait :
            alert.showWait(title, subTitle: subtitle, closeButtonTitle: closeButtonTitle , duration: 15, colorStyle: 0xFF4C5E, colorTextButton: 0xFFFFFF)
        }
    }
    
    func addButton(buttonTitle: String, alert: SCLAlertView, buttonAction: () -> Void) {
        alert.addButton(buttonTitle, action: buttonAction)
    }
    
    
}
