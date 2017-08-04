//
//  ViewController.swift
//  ActionOverlayDemo
//
//  Created by Modeso-5 on 8/1/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import MActionOverlay

class ViewController: UIViewController {

    @IBOutlet weak var actionButton: ActionButton!
    @IBOutlet weak var actionOverlayContainer: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var chartImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: "ellipsis-icon")?.withRenderingMode(.alwaysTemplate)
        actionButton.setImage(img, for: .normal)
        actionButton.tintColor = UIColor.white
        actionButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        actionButton.parentViewController = self
        actionButton.targetView = imgView
        actionButton.overlayViewDelegate = self
        actionButton.overlayButtonsNumber = 3
        actionButton.overlayButtonsIds = [1, 2, 3]
        actionButton.overlayButtonsImages = ["camera-icon", "share-icon", "cloud-icon"]
        actionButton.duration = 0.5
        print(chartImg)
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
