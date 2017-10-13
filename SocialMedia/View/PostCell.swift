//
//  PostCell.swift
//  SocialMedia
//
//  Created by Joseph  Ishak on 10/12/17.
//  Copyright © 2017 Joseph  Ishak. All rights reserved.
//

import UIKit
import Firebase


class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg:     UIImageView!
    @IBOutlet weak var caption:      UITextView!
    @IBOutlet weak var likesLbl:    UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    var likesRef : DatabaseReference!
    var post  : Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        
        
       
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image  = UIImage(named:"filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named:"empty-heart")
               self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        likesRef =  DataServices.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        print("\(post.likes)")
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil{
            self.postImg.image = img
        }else{
            
           let ref  = Storage.storage().reference(forURL: post.imageUrl)
            
            ref.getData(maxSize: 2 * 1024 * 1024,completion: { (data, error) in
                if error != nil{
                    print("Joe: Unable to download image from firebase storage")
                }else {
                    print("Image downloaded form firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                         self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as AnyObject)
                        }
                    }
                }
            })
                
            
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.likeImg.image  = UIImage(named:"empty-heart")
                } else {
                    self.likeImg.image = UIImage(named:"filled-heart")
                }
            })
        }
        
        
        
    }
    
    
    
    
  
}
