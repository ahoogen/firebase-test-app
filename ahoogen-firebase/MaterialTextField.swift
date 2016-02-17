//
//  MaterialTextField.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/16/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: TEXTFIELD_BORDER_ALPHA).CGColor
        layer.borderWidth = 1.0
    }
    
    // For placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    // For input text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
