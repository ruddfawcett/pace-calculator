//
//  MenuView.swift
//  Pace
//
//  Created by Rudd Fawcett on 6/6/17.
//  Copyright © 2017 Rudd Fawcett. All rights reserved.
//

import UIKit

enum MenuItem {
    case Distance, Split, Time
}

protocol MenuDelegate: class {
    func didSelectItem(item: MenuItem)
}

class MenuView: UIView {
    weak var delegate: MenuDelegate?
    
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        distanceButton.alpha = 0.6
        splitButton.alpha = 0.6
        timeButton.alpha = 0.6
        
        sender.alpha = 1
        
        if (sender.tag == 0) {
            delegate?.didSelectItem(item: .Distance)
        }
        else if (sender.tag == 1) {
            delegate?.didSelectItem(item: .Split)
        }
        else {
            delegate?.didSelectItem(item: .Time)
        }
    }
}
