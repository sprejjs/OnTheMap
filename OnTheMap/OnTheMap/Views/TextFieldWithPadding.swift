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
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 20, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 20, 0)
    }
}