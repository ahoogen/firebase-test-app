//
//  DataService.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/17/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://ahoogen.firebaseio.com"
class DataService {
    static let ds = DataService()
    
    private var _base = Firebase(url: BASE_URL)
    private var _posts = Firebase(url: "\(BASE_URL)/posts")
    private var _users = Firebase(url: "\(BASE_URL)/users")
    
    var BASE: Firebase {
        return _base
    }
    
    var POSTS: Firebase {
        return _posts
    }
    
    var USERS: Firebase {
        return _users
    }
    
    var USER_CURRENT: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(USERS)").childByAppendingPath(uid)
        
        return user
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>)
    {
        USERS.childByAppendingPath(uid).setValue(user)
    }
}