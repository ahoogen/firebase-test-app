//
//  Post.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/17/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postDesc: String!
    private var _imgUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    private var _postRef: Firebase!
    
    var postDesc: String {
        return _postDesc
    }
    
    var imgUrl: String? {
        return _imgUrl
    }
    
    var likes: Int {
        get {
            if _likes == nil {
                _likes = 0
            }

            return _likes
        }
        
        set(newValue) {
            if newValue < 0 {
                _likes = 0
            } else {
                _likes = newValue
            }
        }
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, imageUrl: String?, username: String) {
        self._postDesc = description
        self._imgUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDesc = desc
        }
        
        if let img = dictionary["imgUrl"] as? String where img != "" {
            self._imgUrl = img

        }
        
        self._postRef = DataService.ds.POSTS.childByAppendingPath(self._postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            likes += 1
        } else {
            likes -= 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
}