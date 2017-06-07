//
//  CircleImageView.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 28/05/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.width / 2
    }
    
}
