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


    @IBOutlet weak var clockFrontPanel: UIView!

    @IBOutlet weak var clockFrontView: ClockView!
    @IBOutlet weak var clockRearView: UIView!
    @IBOutlet weak var clockFlipButton: UIButton!

    // MARK: - Settings outlets

    @IBOutlet weak var numeralsSetting: UISegmentedControl!
    @IBOutlet weak var ticksSetting: UISegmentedControl!

    // MARK: - Settings

    var highlightColor = UIColor.whiteColor()

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        numeralsSetting.selectedSegmentIndex = NSUserDefaults.readInt(key: ClockKeys.numeralType, defaultValue: NumeralType.Arabic.rawValue)
        ticksSetting.selectedSegmentIndex = NSUserDefaults.readInt(key: ClockKeys.tickmarks, defaultValue: TickMarks.Minutes.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        clockFrontView.shouldUpdateSubviews = true
        clockFrontView.setNeedsDisplay()
    }

    // MARK: - Actions

    @IBAction func actionFlipPanel(sender: UIButton) {
        switch sender {
        case clockFlipButton:
            flip(clockFrontPanel, rearView: clockRearView)
        default:
            break
        }
    }

    @IBAction func actionChangeSettings(sender: UISegmentedControl) {
        switch sender {
        case numeralsSetting:
            NSUserDefaults.writeInt(key: ClockKeys.numeralType, value: numeralsSetting.selectedSegmentIndex)
            clockFrontView.shouldUpdateSubviews = true
            clockFrontView.highlightColor = highlightColor
            clockFrontView.setNeedsDisplay()
        case ticksSetting:
            NSUserDefaults.writeInt(key: ClockKeys.tickmarks, value: ticksSetting.selectedSegmentIndex)
            clockFrontView.shouldUpdateSubviews = true
            clockFrontView.highlightColor = highlightColor
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
}
