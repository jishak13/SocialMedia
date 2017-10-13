//
//  Post.swift
//  SocialMedia
//
//  Created by Joseph  Ishak on 10/13/17.
//  Copyright © 2017 Joseph  Ishak. All rights reserved.
//

import Foundation

class Post{
    
    private var _caption: String!
    private var _likes: Int!
    private var _imageUrl: String!
    private var _postKey: String!
    
    var caption: String{
        get {
            return _caption
        }
        
    }
    
    var likes: Int{
        get{
            return _likes
        }
    }
    var imageUrl:String{
        get{
            return _imageUrl
        }
    }
    var postKey:String{
        get{
            return _postKey
        }
    }
    init(caption: String, imageUrl:String,likes:Int){
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    init(postKey: String,postData:Dictionary<String,AnyObject>){
        self._postKey = postKey
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
    }
}
