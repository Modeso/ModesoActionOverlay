//
//  ModesoCustomButton.swift
//  ModesoActionOverlay
//
//  Created by Modeso-5 on 8/17/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class ModesoCustomButton: UIButton {
    
    var isCloseButton = false
    
    override var isHighlighted: Bool {
        didSet {
            if isCloseButton {
                alpha = isHighlighted ?  0.5: 1.0
            } else {
                alpha = isHighlighted ?  0.7: 1.0
            }
        }
    }
}
