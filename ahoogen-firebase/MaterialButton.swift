//
//  MaterialButton.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/16/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = MATERIAL_VIEW_CORNER_RADIUS
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: SHADOW_ALPHA).CGColor
        layer.shadowOpacity = SHADOW_OPACITY
        layer.shadowRadius = SHADOW_RADIUS
        layer.shadowOffset = CGSizeMake(SHADOW_OFFSET_WIDTH, SHADOW_OFFSET_HEIGHT)
    }

}
