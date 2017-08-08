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
        transition = ModesoOverlayTransition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        actionButton.parentViewController = self
        actionButton.targetView = actionOverlayContainer
        actionButton.overlayViewDelegate = self
        actionButton.overlayButtonsNumber = 3
        actionButton.overlayButtonsIds = [1, 2, 3]
        actionButton.overlayButtonsImages = ["camera-icon", "share-icon", "cloud-icon"]
        actionButton.duration = 0.5
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
        print("buttonID\(id)")
    }
}
