//
//  ViewController.swift
//  ModesoActionOverlayDemo
//
//  Created by Reem Hesham on 8/1/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import ModesoActionOverlay

class ViewController: UIViewController {

    @IBOutlet weak var actionButton: ModesoActionButton!
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

        // set targetView if not set via outlet
//        actionButton.targetView = profileImg    // demo 1
//        actionButton.targetView = chartImg      // demo 2
//        actionButton.targetView = self.view     // demo 3
        
        actionButton.overlayViewDelegate = self
        actionButton.overlayButtonsNumber = 3
        actionButton.overlayButtonsIds = [0, 1, 2, 3, 4]
        actionButton.overlayButtonsImages = ["camera-icon", "share-icon", "cloud-icon", "share-icon", "cloud-icon"]
        actionButton.closeButtonIcon = "close-icon"
        actionButton.duration = 0.25
        actionButton.buttonPressedBackgroundColor = UIColor(red: 194/255, green: 27/255, blue: 79/255, alpha: 1)
        actionButton.transition = transition
    }
    
    func switchTargetView(id: Int) {
        let targetViews = [profileImg, chartImg, self.view]
        actionButton.targetView = targetViews[id<targetViews.count ? id : 0]
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
        actionButton.closeOverlayView?()
        switchTargetView(id: id)
    }
}
