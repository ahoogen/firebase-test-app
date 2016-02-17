//
//  DataService.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/17/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    var ref_base: Firebase {
        get {
            return _ref_base
        }
    }
    
    private var _ref_base = Firebase(url: "https://ahoogen.firebaseio.com")
}