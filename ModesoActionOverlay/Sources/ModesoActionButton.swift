//
//  ModesoActionButton.swift
//  ModesoActionOverlay
//
//  Created by Reem Hesham on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

open class ModesoActionButton: UIButton {

    open var overlayViewDelegate: OverlayViewDelegate?
    /**
     The original point which button will return to after the overlayview disappearance
     */
    private var actionButtonOrigin: CGPoint!

    open var parentViewController: UIViewController?
    open var targetView: UIView!
    open var overlayButtonsNumber: Int!
    open var overlayButtonsIds: [Int]!
    open var overlayButtonsImages: [String]!
    open var transition: UIViewControllerAnimatedTransitioning?
    open var closeButtonIcon: String!
    open var buttonPressedBackgroundColor: UIColor?
    private var originalBackgroundColor: UIColor?

    /**
     The animation duration
     Defaults to `0.25`
     */
    open var duration = 0.25

    override open func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = self.frame.height/2
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
    }

    func buttonPressed() {
        originalBackgroundColor = self.backgroundColor
        self.backgroundColor = buttonPressedBackgroundColor
    }

    func buttonClicked() {
        self.backgroundColor = originalBackgroundColor
        actionButtonOrigin = self.frame.origin
        self.animate(view: self, fromPoint: self.center, toPoint: self.targetView.center)
    }
    
    func instantiateOverlayView() -> ModesoActionOverlayViewController{
        let vc = ModesoActionOverlayViewController()
        vc.view.frame = CGRect(x: targetView.frame.origin.x, y: targetView.frame.origin.y, width: targetView.frame.width, height: targetView.frame.height)
        vc.modalPresentationStyle = .custom
        vc.delegate = overlayViewDelegate
        vc.buttonsNumber = overlayButtonsNumber
        vc.buttonsIds = overlayButtonsIds
        vc.buttonImages = overlayButtonsImages
        vc.closeButtonIcon = closeButtonIcon
        vc.overlayViewStartingPoint = targetView.center
        vc.overlayViewColor = self.backgroundColor
        vc.duration = duration
        vc.modesoOverlayTransition = transition
        return vc
    }

    open func showActionButton() {
        self.isHidden = false
        self.isEnabled = true
        self.alpha = 1
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: duration*0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = .identity
        })
    }

    func animate(view : UIView, fromPoint start : CGPoint, toPoint end: CGPoint)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.alpha = 0.9
            view.layer.removeAnimation(forKey: "move")
            let vc = self.instantiateOverlayView()
            guard let parentViewController = self.parentViewController else {
                return
            }
            parentViewController.present(vc, animated: true, completion:nil)
            self.isEnabled = false
            self.isHidden = true
            self.frame.origin = self.actionButtonOrigin
        })
        // The animation
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        // Animation's path
        let path = UIBezierPath()
        
        // Move the "cursor" to the start
        path.move(to: start)
        
        // Calculate the control points
        let c1 = CGPoint(x: start.x - 64, y: start.y)
        let c2 = CGPoint(x: end.x,        y: end.y + 64)
        
        // Draw a curve towards the end, using control points
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        
        // Use this path as the animation's path (casted to CGPath)
        animation.path = path.cgPath;
        
        // The other animations properties
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = duration
        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        // Apply it
        view.layer.add(animation, forKey:"move")
        CATransaction.commit()
    }
}



