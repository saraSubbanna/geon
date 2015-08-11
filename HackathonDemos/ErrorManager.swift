//
//  ErrorManager.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 8/2/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import AudioToolbox

class ErrorManager: NSObject {
    func popupVibrateAndShakeForError(error: NSError, currView: UIView) {
        println(error.description)
        var errorView: UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 5 / 8, UIScreen.mainScreen().bounds.size.width * 5 / 8))
        var errTitleLabel = UILabel(frame: CGRectMake(0, 0, errorView.bounds.size.width, 24.0))
        errTitleLabel.text = "Error Code \(error.code)"
        var errLabel = UILabel(frame: CGRectMake(0, 24.0, errorView.bounds.size.width, errorView.bounds.size.height - 24.0))
        errLabel.text = "Description \(error.description)"
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        currView.layer.addAnimation( anim, forKey:nil )
        var popup = KLCPopup(contentView: errorView, showType: KLCPopupShowType.BounceInFromTop, dismissType: KLCPopupDismissType.BounceOutToBottom, maskType: KLCPopupMaskType.Dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: true)
        popup.show();
    }
}
