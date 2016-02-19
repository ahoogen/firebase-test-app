//
//  Contsants.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/16/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import Foundation
import UIKit

let MATERIAL_VIEW_CORNER_RADIUS: CGFloat = 2.0
let SHADOW_COLOR: CGFloat = 157.0 / 255.0
let SHADOW_ALPHA: CGFloat = 0.5
let SHADOW_OPACITY: Float = 0.8
let SHADOW_RADIUS: CGFloat = 5.0
let SHADOW_OFFSET_WIDTH: CGFloat = 0.0
let SHADOW_OFFSET_HEIGHT: CGFloat = 2.0
let TEXTFIELD_BORDER_ALPHA: CGFloat = 0.1

// Keys
let KEY_UID = "uid"

// Segues
let SEGUE_LOGGED_IN = "LoggedIn"

// Status codes
let STATUS_ACCOUNT_NONEXIST = -8
let STATUS_INVALID_PASSWORD = -6

// External Resources
let IMAGE_SHACK_API_KEY: String = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3"

// Constraint debug output
extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}