//
//  ActionButton.swift
//  MActionOverlay
//
//  Created by Reem Hesham on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

open class ActionButton: UIButton {

    /**
     The transitionDelegate
     */
    open var transitionDelegate: UIViewControllerTransitioningDelegate?
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
    /**
     The animation duration
     Defaults to `0.5`
     */
    open var duration = 0.5

    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.height/2
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonClicked(_:))))
        
    }

    func buttonClicked(_ sender: UITapGestureRecognizer) {

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
    
    func instantiateOverlayView() -> OverlayViewController{
        let vc = OverlayViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: targetView.frame.width, height: targetView.frame.height)
        vc.view.bounds = CGRect(x: 0, y: 0, width: targetView.frame.width, height: targetView.frame.height)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionDelegate
        vc.delegate = overlayViewDelegate
        vc.buttonsNumber = overlayButtonsNumber
        vc.buttonsIds = overlayButtonsIds
        vc.buttonImages = overlayButtonsImages
        vc.overlayViewStartingPoint = targetView.center
        vc.overlayViewColor = self.backgroundColor
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



