//
//  RoundBtn.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 25/05/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0) // width 1.0 right and left || height 1.0 top and down
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    //the width are not good in awakeFromNib so we use below func
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }

}
