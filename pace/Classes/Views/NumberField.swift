//
//  NumberField.swift
//  Pace
//
//  Created by Rudd Fawcett on 6/6/17.
//  Copyright © 2017 Rudd Fawcett. All rights reserved.
//

import UIKit

class NumberField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10 , dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
}
