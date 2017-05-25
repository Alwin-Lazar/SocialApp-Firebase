//
//  FancyField.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 25/05/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
    
    //PlaceHolder Text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // 10 from left and right
        // 5 from top and bottom
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    //Real Text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
