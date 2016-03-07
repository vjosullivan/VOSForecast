//
//  VOSClockViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 05/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class VOSClockViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var clockFrontView: VOSClockView!
    @IBOutlet weak var clockRearView: UIView!
    @IBOutlet weak var clockFlipButton: UIButton!

    var parentVC: VOSClockDelegate?

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            print("Landscape: size = \(size.width)x\(size.height)")
        } else {
            print("Portrait: size = \(size.width)x\(size.height)")
        }
        clockFrontView.shouldUpdateSubviews = true
        clockFrontView.setNeedsDisplay()
    }

    // MARK: - Actions

    @IBAction func actionFlipPanel(sender: UIButton) {
        switch sender {
        case clockFlipButton:
            flip(clockFrontView, rearView: clockRearView)
        default:
            break
        }
    }

    // MARK: - Local functions

    func flip(frontView: UIView, rearView: UIView) {
        if rearView.hidden {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromRight, .ShowHideTransitionViews]
            UIView.transitionWithView(frontView, duration: 1.0, options: transitionOptions, animations: { frontView.hidden = true  }, completion: nil)
            UIView.transitionWithView(rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.hidden  = false }, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromLeft, .ShowHideTransitionViews]
            UIView.transitionWithView(rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.hidden  = true  }, completion: nil)
            UIView.transitionWithView(frontView, duration: 1.0, options: transitionOptions, animations: { frontView.hidden = false }, completion: nil)
        }
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        parentVC = parent as? VOSClockDelegate
    }
}
