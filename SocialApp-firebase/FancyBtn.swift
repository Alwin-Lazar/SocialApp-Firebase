//
//  FancyBtn.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 25/05/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit

class FancyBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        //there is no subviews so put it here
        layer.cornerRadius = 2.0
    }
    
}
