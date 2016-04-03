//
//  MainViewControllerExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 03/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

extension MainViewController {
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        setConstraints(toInterfaceOrientation)
    }

    private func setConstraints(toInterfaceOrientation: UIInterfaceOrientation) {
        print("Rotating...")
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
            print("...to landscape.")
            setLandscapeConstraints()
            print("Rotating...")
        } else {
            print("...to portrait.")
            setPortraitConstraints()
        }
    }

    private func setPortraitConstraints() {
        print("\n\nPortrait", view.frame, view.bounds)

        let w  = view.bounds.size.height / 4.0
        let ww = view.bounds.size.height / 2.0
        print("ww", ww)
        let h = view.bounds.size.width - UIApplication.sharedApplication().statusBarFrame.size.height

        constraintClockTop.constant      = 0.0
        constraintClockBottom.constant   = h - ww + halfPad
        constraintClockLeading.constant  = padding
        constraintClockTrailing.constant = ww + halfPad

        constraintWeatherTop.constant      = 0.0
        constraintWeatherBottom.constant   = h - ww + halfPad
        constraintWeatherLeading.constant  = ww + halfPad
        constraintWeatherTrailing.constant = padding

        constraintAstrolabeTop.constant      = ww + halfPad
        constraintAstrolabeBottom.constant   = h - 2 * ww + halfPad
        constraintAstrolabeLeading.constant  = padding
        constraintAstrolabeTrailing.constant = ww + halfPad

        constraintRainTop.constant      = ww + halfPad
        constraintRainBottom.constant   = h - 2 * ww + halfPad
        constraintRainLeading.constant  = ww + halfPad
        constraintRainTrailing.constant = padding

        constraintATop.constant      = 2 * ww + halfPad
        constraintABottom.constant   = h - 4.5 * w + halfPad
        constraintALeading.constant  = padding
        constraintATrailing.constant = 3 * w + halfPad

        constraintBTop.constant      = 2 * ww + halfPad
        constraintBBottom.constant   = h - 4.5 * w + halfPad
        constraintBLeading.constant  = w + halfPad
        constraintBTrailing.constant = ww + halfPad

        constraintCTop.constant      = 2 * ww + halfPad
        constraintCBottom.constant   = h - 4.5 * w + halfPad
        constraintCLeading.constant  = ww + halfPad
        constraintCTrailing.constant = w + halfPad

        constraintDTop.constant      = 2 * ww + halfPad
        constraintDBottom.constant   = h - 4.5 * w + halfPad
        constraintDLeading.constant  = 3 * w + halfPad
        constraintDTrailing.constant = padding

        constraintSummaryTop.constant      = 4.5 * w + halfPad
        constraintSummaryBottom.constant   = padding
        constraintSummaryLeading.constant  = padding
        constraintSummaryTrailing.constant = padding
    }

    private func setLandscapeConstraints() {
        print("\n\nLandscape", view.frame, view.bounds)

        let w6 = view.bounds.size.height / 6.0
        let w2 = view.bounds.size.height / 2.0
        let w3 = view.bounds.size.height / 3.0
        let w23 = view.bounds.size.height * 2.0 / 3.0
        let h = view.bounds.size.width - UIApplication.sharedApplication().statusBarFrame.size.height

        constraintClockTop.constant      = 0.0
        constraintClockBottom.constant   = h - w3 + halfPad
        constraintClockLeading.constant  = padding
        constraintClockTrailing.constant = w23 + halfPad

        constraintWeatherTop.constant      = w3 + halfPad
        constraintWeatherBottom.constant   = h - w23 + halfPad
        constraintWeatherLeading.constant  = padding
        constraintWeatherTrailing.constant = w23 + halfPad

        constraintAstrolabeTop.constant      = 0.0
        constraintAstrolabeBottom.constant   = h - w3 + halfPad
        constraintAstrolabeLeading.constant  = w23 + halfPad
        constraintAstrolabeTrailing.constant = padding

        constraintRainTop.constant      = w3 + halfPad
        constraintRainBottom.constant   = h - w23 + halfPad
        constraintRainLeading.constant  = w23 + halfPad
        constraintRainTrailing.constant = padding

        constraintATop.constant      = 0.0
        constraintABottom.constant   = h - 1 * w6 + halfPad
        constraintALeading.constant  = w3 + halfPad
        constraintATrailing.constant = w3 + halfPad

        constraintBTop.constant      = w6 + halfPad
        constraintBBottom.constant   = h - w3 + halfPad
        constraintBLeading.constant  = w3 + halfPad
        constraintBTrailing.constant = w3 + halfPad

        constraintCTop.constant      = w3 + halfPad
        constraintCBottom.constant   = h - w2 + halfPad
        constraintCLeading.constant  = w3 + halfPad
        constraintCTrailing.constant = w3 + halfPad

        constraintDTop.constant      = w2 + halfPad
        constraintDBottom.constant   = h - w23 + halfPad
        constraintDLeading.constant  = w3 + halfPad
        constraintDTrailing.constant = w3 + halfPad

        constraintSummaryTop.constant      = w23 + halfPad
        constraintSummaryBottom.constant   = padding
        constraintSummaryLeading.constant  = padding
        constraintSummaryTrailing.constant = padding
    }
}
