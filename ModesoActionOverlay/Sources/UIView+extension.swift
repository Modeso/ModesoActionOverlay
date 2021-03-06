//
//  UIView+extension.swift
//  ModesoActionOverlay
//
//  Created by Reem Hesham on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath        
        self.layer.mask = maskLayer
    }

    func mask(withRects rects: [CGRect], inverse: Bool = false) {
        let path = UIBezierPath()
        for rect in rects {
            path.append(UIBezierPath(rect: rect))
        }
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
