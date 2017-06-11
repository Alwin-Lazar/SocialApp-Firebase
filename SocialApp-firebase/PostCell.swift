//
//  PostCell.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 07/06/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.captionTextView.text = post.caption
        self.likesLbl.text = "\(post.likes)"
    }
}
