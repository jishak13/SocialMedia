//
//  PostCell.swift
//  SocialMedia
//
//  Created by Joseph  Ishak on 10/12/17.
//  Copyright © 2017 Joseph  Ishak. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg:     UIImageView!
    @IBOutlet weak var caption:      UITextView!
    @IBOutlet weak var likesLbl:    UILabel!
    
    var post  : Post!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configureCell(post: Post){
        self.post = post
        self.caption.text = post.caption
        print("\(post.likes)")

        self.likesLbl.text = "\(post.likes)"
        
    }
    
    
    
    
  
}
