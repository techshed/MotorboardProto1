//
//  CustomTextfield.swift
//  MotorboardProto1
//
//  Created by Pete Petrash on 12/3/14.
//  Copyright (c) 2014 Techshed. All rights reserved.
//

import UIKit

class CustomTextField : UITextField {
    var leftTextMargin : CGFloat = 0.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        newBounds.inset(dx: 13.0, dy: 12.0)
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        newBounds.inset(dx: 13.0, dy: 12.0)
        return newBounds
    }
}
