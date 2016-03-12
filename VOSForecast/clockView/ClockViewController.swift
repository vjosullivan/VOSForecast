//
//  ClockViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 05/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var clockFrontView: ClockView!
    @IBOutlet weak var clockRearView: UIView!
    @IBOutlet weak var clockFlipButton: UIButton!

    var parentVC: ClockDelegate?

    // MARK: - Settings outlets

    @IBOutlet weak var numeralsSetting: UISegmentedControl!
    @IBOutlet weak var ticksSetting: UISegmentedControl!

    // MARK: - Settings

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        numeralsSetting.selectedSegmentIndex = NSUserDefaults.readInt(key: "numerals", defaultValue: Numerals.Arabic.rawValue)
        ticksSetting.selectedSegmentIndex = NSUserDefaults.readInt(key: "tickmarks", defaultValue: TickMarks.Minutes.rawValue)
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

    @IBAction func actionChangeSettings(sender: UISegmentedControl) {
        switch sender {
        case numeralsSetting:
            NSUserDefaults.writeInt(key: "numerals", value: numeralsSetting.selectedSegmentIndex)
            clockFrontView.shouldUpdateSubviews = true
            clockFrontView.setNeedsDisplay()
        case ticksSetting:
            NSUserDefaults.writeInt(key: "tickmarks", value: ticksSetting.selectedSegmentIndex)
            clockFrontView.shouldUpdateSubviews = true
            clockFrontView.setNeedsDisplay()
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
        parentVC = parent as? ClockDelegate
    }
}
