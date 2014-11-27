//
//  Hud.swift
//  LoadingHud
//
//  Created by Stephen Kyles on 9/13/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import Foundation
import UIKit

class Hud {
    var hudView: UIView
    var hudMessage: String
    var messageLabel: UILabel
    var activityIndicator: UIActivityIndicatorView
    
    init(viewFrame: CGRect, hudMessage: String) {
        // hud
        self.hudView = UIView(frame: CGRectMake(0, 0, 130, 40))
        self.hudView.center = CGPointMake(viewFrame.size.width/2, viewFrame.size.height/3)
        self.hudView.layer.cornerRadius = 10
        self.hudView.backgroundColor = .blackColor()

        // message
        self.hudMessage = hudMessage
        self.messageLabel = UILabel(frame: CGRectMake(13, 0, self.hudView.frame.size.width, 40))
        self.messageLabel.textColor = UIColor.whiteColor()
        self.messageLabel.text = self.hudMessage
        self.messageLabel.textAlignment = NSTextAlignment.Center
        self.hudView.addSubview(messageLabel)
        
        // activity indicator
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.activityIndicator.center = CGPointMake(23,20)
        self.hudView.addSubview(self.activityIndicator)
    }
    
    func StartIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func StopIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
    func HudView() -> UIView {
        return self.hudView
    }
}