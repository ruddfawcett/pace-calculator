//
//  BorderedView.swift
//  Pace
//
//  Created by Rudd Fawcett on 6/6/17.
//  Copyright © 2017 Rudd Fawcett. All rights reserved.
//

import UIKit

class BorderedView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let borderBottom = UIView()
        borderBottom.backgroundColor = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.00)
        borderBottom.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        borderBottom.frame = CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5)
        
        addSubview(borderBottom)
        
        let borderTop = UIView()
        borderTop.backgroundColor = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.00)
        borderTop.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        borderTop.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.5)
        
        addSubview(borderTop)
    }
    
}
