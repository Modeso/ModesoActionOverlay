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
    
    /**
     The animation duration
     Defaults to `0.5`
     */
    open var duration = 0.5

    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.height/2
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }

    func buttonClicked() {

        actionButtonOrigin = self.frame.origin
        UIView.animate(withDuration: duration, animations: {
            
            self.center.x = (self.targetView.center.x)
            self.center.y = self.targetView.center.y
            self.alpha = 0.9
        }, completion: { _ in
            
            let vc = self.instantiateOverlayView()
            guard let parentViewController = self.parentViewController else {
                return
            }
            parentViewController.present(vc, animated: true, completion:nil)
            self.isEnabled = false
            self.isHidden = true
            self.frame.origin = self.actionButtonOrigin
        })
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
        UIView.animate(withDuration: 0.30, animations: {
            self.transform = .identity
        })
    }
}



