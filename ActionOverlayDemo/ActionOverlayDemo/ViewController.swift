//
//  ViewController.swift
//  ActionOverlayDemo
//
//  Created by Modeso-5 on 8/1/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import ModesoActionOverlay

class ViewController: UIViewController {

    @IBOutlet weak var actionButton: ModesoActionButton!
    @IBOutlet weak var actionOverlayContainer: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var chartImg: UIImageView!

    var transition: ModesoOverlayTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: "ellipsis-icon")?.withRenderingMode(.alwaysTemplate)
        actionButton.setImage(img, for: .normal)
        actionButton.tintColor = UIColor.white
        actionButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        actionButton.adjustsImageWhenHighlighted = false
        // Shadow and Radius
        actionButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = 1.0
        actionButton.layer.shadowRadius = 0.0
        actionButton.layer.masksToBounds = false
        transition = ModesoOverlayTransition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        actionButton.parentViewController = self
        actionButton.targetView = chartImg
        actionButton.overlayViewDelegate = self
        actionButton.overlayButtonsNumber = 5
        actionButton.overlayButtonsIds = [1, 2, 3, 4, 5]
        actionButton.overlayButtonsImages = ["camera-icon", "share-icon", "cloud-icon", "share-icon", "cloud-icon"]
        actionButton.closeButtonIcon = "close-icon"
        actionButton.duration = 0.25    
        actionButton.transition = transition
    }
}

//MARK:- UIViewControllerTransitioningDelegate methods
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

//MARK:- OverlayViewDelegate methods
extension ViewController: OverlayViewDelegate {
    func showActionButton() {
        actionButton.showActionButton()
    }
    func buttonClicked(id: Int) {
        print("buttonID \(id)")
    }
}
