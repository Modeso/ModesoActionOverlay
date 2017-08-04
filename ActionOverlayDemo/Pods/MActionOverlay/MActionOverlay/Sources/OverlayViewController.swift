//
//  OverlayViewController.swift
//  MActionOverlay
//
//  Created by Reem Hesham on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    /**
     The presented buttons numbers with range 1..5
     */
    open var buttonsNumber: Int? {
        didSet {
            if let buttonsNo = buttonsNumber, buttonsNo > 5 {
                buttonsNumber = 5
            }
        }
    }
    /**
     The presented buttons images names
     */
    open var buttonImages: [String]?
    open var buttonsIds: [Int]?
    private var buttonsCount = 0
    private var buttons: [UIButton] = []
    var delegate: OverlayViewDelegate?
    var overlayViewStartingPoint: CGPoint!
    var overlayViewColor: UIColor!

    private var closeButton: UIButton!
    /**
     The transition duration
     Defaults to `0.5`
     */
    var duration = 0.5
    private let buttonWidth: CGFloat = 60

    open var overlayTransition: UIViewControllerAnimatedTransitioning?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard  let buttonImages = buttonImages else {
            return
        }
        addButton(buttonImage: buttonImages[buttonsCount], count: buttonsCount)
        /**
         add a close button to the overlay view
         the close button rotat by angle 180 degree during the displaying of the presented buttons
         */
        closeButton = addCloseButton()
        closeButton.alpha = 0
        closeButton.transform = CGAffineTransform(rotationAngle: 180)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.closeButton.alpha = 1
            self.closeButton.transform = CGAffineTransform.identity
        })
        
    }

    func addButton(buttonImage: String, count: Int) {

        let newButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonWidth))
        newButton.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        newButton.layer.cornerRadius = newButton.frame.height/2
        newButton.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: buttonImage)?.withRenderingMode(.alwaysTemplate)
        newButton.setImage(img, for: .normal)
        newButton.tintColor = UIColor.white
        newButton.imageEdgeInsets = UIEdgeInsetsMake(20,20,20,20)
        guard  let buttonsIds = buttonsIds else {
            return
        }
        newButton.tag = buttonsIds[count]
        newButton.addTarget(self, action: #selector(overlayButtonClicked(_:)), for: .touchUpInside)
        buttons.append(newButton)
        view.addSubview(newButton)

        guard  let buttonsNumber = buttonsNumber else {
            return
        }
        // add button constraints
        let constrains = (view.frame.width - CGFloat(buttonsNumber) * buttonWidth) * CGFloat(count+1)/CGFloat(buttonsNumber + 1) + buttonWidth*CGFloat(count)

        let horizontalLeftConstraint = NSLayoutConstraint(item: newButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: constrains)
        let verticalConstraint = NSLayoutConstraint(item: newButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: newButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: buttonWidth)
        let heightConstraint = NSLayoutConstraint(item: newButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: buttonWidth)
        
        view.addConstraints([horizontalLeftConstraint, verticalConstraint, widthConstraint, heightConstraint])

        // buttons are displayed in scale transformation after each other
        newButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

        UIView.animate(withDuration: 0.10, animations: {
            newButton.transform = CGAffineTransform.identity
        }) { (_) in
            self.buttonsCount += 1
            if self.buttonsCount < buttonsNumber {
                guard  let buttonImages = self.buttonImages else {
                    return
                }
                self.addButton(buttonImage: buttonImages[self.buttonsCount], count: self.buttonsCount)
            }
        }

    }

    func addCloseButton() -> UIButton {
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let img = UIImage(named: "delete-icon")?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(img, for: .normal)
        closeButton.tintColor = UIColor.white
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeOverlayView), for: .touchUpInside)
        view.addSubview(closeButton)

        let horizontalLeftConstraint = NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.trailingMargin, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20)
        let widthConstraint = NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        let heightConstraint = NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        
        view.addConstraints([horizontalLeftConstraint, verticalConstraint, widthConstraint, heightConstraint])
        return closeButton
    }
    
    func closeOverlayView() {
        closeButton.transform = CGAffineTransform(rotationAngle: -180)
        buttonsCount = self.buttons.count - 1
        UIView.animate(withDuration: 0.5, animations: {
            self.closeButton.alpha = 0
            self.closeButton.transform = CGAffineTransform.identity
        })
        removeButton()
    }
    
    func removeButton() {
        UIView.animate(withDuration: 0.10, animations: {
            self.buttons[self.buttonsCount].transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            
        }) { (_) in
            self.buttonsCount -= 1
            if self.buttonsCount >= 0 {
                self.removeButton()
            } else {
                UIView.animate(withDuration: 0.10, animations: {
                    self.view.alpha = 0
                }) { (_) in
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }

    func overlayButtonClicked(_ sender: UIButton) {
        delegate?.buttonClicked(id: sender.tag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.showActionButton()
    }
}

//MARK:- UIViewControllerTransitioningDelegate methods
extension OverlayViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let transition = overlayTransition as? OverlayTransition else {
            let transition = OverlayTransition()
            transition.startingPoint = overlayViewStartingPoint
            transition.overlayViewColor = overlayViewColor
            transition.duration = duration
            return transition
        }
        
        transition.startingPoint = overlayViewStartingPoint
        transition.overlayViewColor = overlayViewColor
        transition.duration = duration
        return delegate?.animationController?(forPresented:presented, presenting:presenting, source:source)
        
    }
}

public protocol OverlayViewDelegate: UIViewControllerTransitioningDelegate {
    func showActionButton()
    func buttonClicked(id: Int)
}
