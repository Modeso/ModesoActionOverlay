//
//  ModesoCustomButton.swift
//  ModesoActionOverlay
//
//  Created by Modeso-5 on 8/17/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class ModesoCustomButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ?  0.5 : 1.0
        }
    }
}
