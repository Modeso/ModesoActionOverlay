
//
//  ModesoOverlayTransition.swift
//  ModesoActionOverlay
//
//  Created by Reem Hesham on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

open class ModesoOverlayTransition: NSObject {
    /**
     The overlayView starts from this point
     */
    open var startingPoint = CGPoint.zero {
        didSet {
            overlayView.center = startingPoint
        }
    }
    /**
     The transition duration
     Defaults to `0.25`
     */
    open var duration = 0.25
    
    /**
     The color of the overlayView. Make sure that it matches the action button's background color.
     */
    open var overlayViewColor: UIColor = .white
    
    open fileprivate(set) var overlayView = UIView()

}

extension ModesoOverlayTransition: UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning delegate methods
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let modalControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        //center point of the presented controller view.
        let originalSize = modalControllerView.frame.size
        // create the overlay view which start from the center of the modal controller view
        overlayView = UIView()
        overlayView.frame = frameForOverlayView(originalSize, start: startingPoint)
        overlayView.layer.cornerRadius = overlayView.frame.size.height / 2
        overlayView.center = startingPoint
        overlayView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        overlayView.backgroundColor = overlayViewColor.withAlphaComponent(0.9)
        containerView.addSubview(overlayView)
        // create mask for the overlay view
        let lowerMask = CGRect(x: modalControllerView.frame.origin.x, y: modalControllerView.frame.origin.y + originalSize.height, width: originalSize.width, height: containerView.frame.height - originalSize.height)
        let upperMask = CGRect(x: modalControllerView.frame.origin.x, y: 0, width: originalSize.width, height: modalControllerView.frame.origin.y)
        containerView.mask(withRects: [upperMask, lowerMask], inverse: true)

        modalControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        modalControllerView.layer.cornerRadius = modalControllerView.frame.size.height / 2
        modalControllerView.alpha = 0
        
        containerView.addSubview(modalControllerView)
        
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            self.overlayView.transform = CGAffineTransform.identity
            self.overlayView.layoutIfNeeded()

        }, completion: { (_) in
            self.overlayView.isHidden = true
            modalControllerView.transform = CGAffineTransform.identity
            modalControllerView.alpha = 1
            modalControllerView.backgroundColor = self.overlayViewColor.withAlphaComponent(0.9)
            transitionContext.completeTransition(true)
            self.overlayView.removeFromSuperview()

        })
    }
}

private extension ModesoOverlayTransition {
    func frameForOverlayView(_ originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x)
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
}
