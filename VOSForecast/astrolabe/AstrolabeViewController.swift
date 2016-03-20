//
//  File.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class AstrolabeViewController: UIViewController {

    // MARK: - Outlets


    @IBOutlet weak var astrolabeFrontPanel: UIView!
    @IBOutlet weak var astrolabeRearPanel: UIView!

    @IBOutlet weak var astrolabeFrontView: AstrolabeView!
    @IBOutlet weak var astrolabeFlipButton: UIButton!

    var parentVC: AstrolabeDelegate?

    // MARK: - Settings outlets

    @IBOutlet weak var numeralsSetting: UISegmentedControl!
    @IBOutlet weak var ticksSetting: UISegmentedControl!

    // MARK: - Settings

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        numeralsSetting.selectedSegmentIndex = NSUserDefaults.readInt(key: "astrolabe.numerals", defaultValue: Numerals.Arabic.rawValue)
        ticksSetting.selectedSegmentIndex = NSUserDefaults.readInt(key: "astrolabe.tickmarks", defaultValue: TickMarks.Minutes.rawValue)
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
        astrolabeFrontView.shouldUpdateSubviews = true
        astrolabeFrontView.setNeedsDisplay()
    }

    // MARK: - Actions

    @IBAction func actionFlipPanel(sender: UIButton) {
        switch sender {
        case astrolabeFlipButton:
            flip(astrolabeFrontPanel, rearView: astrolabeRearPanel)
        default:
            break
        }
    }

    @IBAction func actionChangeSettings(sender: UISegmentedControl) {
        switch sender {
        case numeralsSetting:
            NSUserDefaults.writeInt(key: "astrolabe.numerals", value: numeralsSetting.selectedSegmentIndex)
            astrolabeFrontView.shouldUpdateSubviews = true
            astrolabeFrontView.setNeedsDisplay()
        case ticksSetting:
            NSUserDefaults.writeInt(key: "astrolabe.tickmarks", value: ticksSetting.selectedSegmentIndex)
            astrolabeFrontView.shouldUpdateSubviews = true
            astrolabeFrontView.setNeedsDisplay()
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
        parentVC = parent as? AstrolabeDelegate
    }
}
