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

    var highlightColor = UIColor.white

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        numeralsSetting.selectedSegmentIndex = UserDefaults.readInt(key: ClockKeys.numeralType, defaultValue: NumeralType.arabic.rawValue)
        ticksSetting.selectedSegmentIndex = UserDefaults.readInt(key: ClockKeys.tickmarks, defaultValue: TickMarks.minutes.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        clockFrontView.shouldUpdateSubviews = true
        clockFrontView.setNeedsDisplay()
    }

    // MARK: - Actions

    @IBAction func actionFlipPanel(_ sender: UIButton) {
        switch sender {
        case clockFlipButton:
            flip(clockFrontPanel, rearView: clockRearView)
        default:
            break
        }
    }

    @IBAction func actionChangeSettings(_ sender: UISegmentedControl) {
        switch sender {
        case numeralsSetting:
            UserDefaults.writeInt(key: ClockKeys.numeralType, value: numeralsSetting.selectedSegmentIndex)
            clockFrontView.shouldUpdateSubviews = true
            clockFrontView.highlightColor = highlightColor
            clockFrontView.setNeedsDisplay()
        case ticksSetting:
            UserDefaults.writeInt(key: ClockKeys.tickmarks, value: ticksSetting.selectedSegmentIndex)
            clockFrontView.shouldUpdateSubviews = true
            clockFrontView.highlightColor = highlightColor
            clockFrontView.setNeedsDisplay()
        default:
            break
        }
    }

    // MARK: - Local functions

    func flip(_ frontView: UIView, rearView: UIView) {
        if rearView.isHidden {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions, animations: { frontView.isHidden = true  }, completion: nil)
            UIView.transition(with: rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.isHidden  = false }, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(with: rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.isHidden  = true  }, completion: nil)
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions, animations: { frontView.isHidden = false }, completion: nil)
        }
    }
}
