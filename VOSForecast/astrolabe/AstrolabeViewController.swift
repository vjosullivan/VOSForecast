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

    // MARK: - Settings outlets

    @IBOutlet weak var numeralsSetting: UISegmentedControl!
    @IBOutlet weak var ticksSetting: UISegmentedControl!

    // MARK: - Settings

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        numeralsSetting.selectedSegmentIndex = UserDefaults.readInt(key: AstrolabeKeys.numeralType, defaultValue: NumeralType.arabic.rawValue)
        ticksSetting.selectedSegmentIndex = UserDefaults.readInt(key: AstrolabeKeys.tickmarks, defaultValue: TickMarks.minutes.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        astrolabeFrontView.shouldUpdateSubviews = true
        astrolabeFrontView.setNeedsDisplay()
    }

    // MARK: - Actions

    @IBAction func actionFlipPanel(_ sender: UIButton) {
        switch sender {
        case astrolabeFlipButton:
            flip(astrolabeFrontPanel, rearView: astrolabeRearPanel)
        default:
            break
        }
    }

    @IBAction func actionChangeSettings(_ sender: UISegmentedControl) {
        switch sender {
        case numeralsSetting:
            UserDefaults.writeInt(key: AstrolabeKeys.numeralType, value: numeralsSetting.selectedSegmentIndex)
            astrolabeFrontView.shouldUpdateSubviews = true
            astrolabeFrontView.setNeedsDisplay()
        case ticksSetting:
            UserDefaults.writeInt(key: AstrolabeKeys.tickmarks, value: ticksSetting.selectedSegmentIndex)
            astrolabeFrontView.shouldUpdateSubviews = true
            astrolabeFrontView.setNeedsDisplay()
        default:
            break
        }
    }

    // MARK: - Local functions

    func updateView(_ data: DataPoint) {
        
    }

    fileprivate func flip(_ frontView: UIView, rearView: UIView) {
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
