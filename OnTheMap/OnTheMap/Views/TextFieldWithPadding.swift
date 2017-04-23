//
//  TextFieldWithPadding.swift
//  OnTheMap
//
//  Created by Vlad Spreys on 16/03/15.
//  Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation

class TextFieldWithPadding : UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
}
