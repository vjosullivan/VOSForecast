//
//  MainViewControllerExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 03/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

extension MainViewController {
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        setConstraints(orientation: toInterfaceOrientation)
    }

    func setConstraints(orientation: UIInterfaceOrientation) {
        print("Rotating...")
        if UIInterfaceOrientationIsLandscape(orientation) {
            print("...to landscape.")
            setLandscapeConstraints()
            print("Rotating...")
        } else {
            print("...to portrait.")
            setPortraitConstraints()
        }
    }

    fileprivate func setPortraitConstraints() {
        print("\n\nPortrait", view.frame, view.bounds, UIApplication.shared.statusBarFrame.size.height)

        let quarterWidth: CGFloat
        let halfWidth: CGFloat
        let height: CGFloat
        let squareWidth: CGFloat
        if initialLayout {
            quarterWidth  = view.bounds.size.width / 4.0
            halfWidth = view.bounds.size.width / 2.0
            height = view.bounds.size.height - UIApplication.shared.statusBarFrame.size.height
            squareWidth = (view.bounds.size.width - 3 * padding) / 2.0
        } else {
            quarterWidth  = view.bounds.size.height / 4.0
            halfWidth = view.bounds.size.height / 2.0
            height = view.bounds.size.width - UIApplication.shared.statusBarFrame.size.height
            squareWidth = (view.bounds.size.height - 3 * padding) / 2.0
        }
        let smallSquareWidth = (squareWidth - padding) / 2.0
        initialLayout = false
        print("halfWidth", halfWidth, "squareWidth", squareWidth)

        constraintClockTop.constant      = 0.0
        constraintClockBottom.constant   = height - squareWidth
        constraintClockLeading.constant  = padding
        constraintClockTrailing.constant = halfWidth + halfPad
        print("Clock: t0.0, b\(height - halfWidth + halfPad) l\(padding) r\(halfWidth + halfPad)")

        constraintWeatherTop.constant      = 0.0
        constraintWeatherBottom.constant   = height - squareWidth
        constraintWeatherLeading.constant  = halfWidth + halfPad
        constraintWeatherTrailing.constant = padding

        constraintAstrolabeTop.constant      = squareWidth + padding
        constraintAstrolabeBottom.constant   = height - 2 * squareWidth - padding
        constraintAstrolabeLeading.constant  = padding
        constraintAstrolabeTrailing.constant = halfWidth + halfPad

        constraintRainTop.constant      = squareWidth + padding
        constraintRainBottom.constant   = height - 2 * squareWidth - padding
        constraintRainLeading.constant  = halfWidth + halfPad
        constraintRainTrailing.constant = padding

        constraintATop.constant      = 2 * (squareWidth + padding)
        constraintABottom.constant   = height - 2 * squareWidth - 2 * padding - smallSquareWidth / 2.0
        constraintALeading.constant  = padding
        constraintATrailing.constant = 3 * quarterWidth + halfPad

        constraintBTop.constant      = 2 * halfWidth - padding
        constraintBBottom.constant   = height - 2 * squareWidth - 2 * padding - smallSquareWidth / 2.0
        constraintBLeading.constant  = quarterWidth + halfPad
        constraintBTrailing.constant = halfWidth + halfPad

        constraintCTop.constant      = 2 * halfWidth - padding
        constraintCBottom.constant   = height - 2 * squareWidth - 2 * padding - smallSquareWidth / 2.0
        constraintCLeading.constant  = halfWidth + halfPad
        constraintCTrailing.constant = quarterWidth + halfPad

        constraintDTop.constant      = 2 * halfWidth - padding
        constraintDBottom.constant   = height - 2 * squareWidth - 2 * padding - smallSquareWidth / 2.0
        constraintDLeading.constant  = 3 * quarterWidth + halfPad
        constraintDTrailing.constant = padding

        constraintSummaryTop.constant      = 2 * (squareWidth + padding) + smallSquareWidth / 2.0 + padding
        constraintSummaryBottom.constant   = padding
        constraintSummaryLeading.constant  = padding
        constraintSummaryTrailing.constant = padding
    }

    fileprivate func setLandscapeConstraints() {
        print("\n\nLandscape", view.frame, view.bounds)

        //let w6: CGFloat
        //let w2: CGFloat
        let w3: CGFloat
        let w23: CGFloat
        let h: CGFloat
        let squareWidth: CGFloat
        if initialLayout {
            //w6 = view.bounds.size.width / 6.0
            //w2 = view.bounds.size.width / 2.0
            w3 = view.bounds.size.width / 3.0
            w23 = view.bounds.size.width * 2.0 / 3.0
            h = view.bounds.size.height - UIApplication.shared.statusBarFrame.size.height
            squareWidth = (view.bounds.size.width - 4.0 * padding) / 3.0
        } else {
            //w6 = view.bounds.size.height / 6.0
            //w2 = view.bounds.size.height / 2.0
            w3 = view.bounds.size.height / 3.0
            w23 = view.bounds.size.height * 2.0 / 3.0
            h = view.bounds.size.width - UIApplication.shared.statusBarFrame.size.height
            squareWidth = (view.bounds.size.height - 4.0 * padding) / 3.0
        }
        let smallSquareWidth = (squareWidth - padding) / 2.0
        initialLayout = false

        constraintClockTop.constant      = 0.0
        constraintClockBottom.constant   = h - squareWidth
        constraintClockLeading.constant  = padding
        constraintClockTrailing.constant = w23 + halfPad

        constraintWeatherTop.constant      = squareWidth + padding
        constraintWeatherBottom.constant   = h - 2 * squareWidth - padding
        constraintWeatherLeading.constant  = padding
        constraintWeatherTrailing.constant = w23 + halfPad

        constraintAstrolabeTop.constant      = 0.0
        constraintAstrolabeBottom.constant   = h - squareWidth
        constraintAstrolabeLeading.constant  = w23 + halfPad
        constraintAstrolabeTrailing.constant = padding

        constraintRainTop.constant      = squareWidth + padding
        constraintRainBottom.constant   = h - 2 * squareWidth - padding
        constraintRainLeading.constant  = w23 + halfPad
        constraintRainTrailing.constant = padding

        constraintATop.constant      = 0.0
        constraintABottom.constant   = h - smallSquareWidth
        constraintALeading.constant  = w3 + halfPad
        constraintATrailing.constant = w3 + halfPad

        constraintBTop.constant      = smallSquareWidth + padding
        constraintBBottom.constant   = h - 2 * smallSquareWidth - padding
        constraintBLeading.constant  = w3 + halfPad
        constraintBTrailing.constant = w3 + halfPad

        constraintCTop.constant      = 2.0 * (smallSquareWidth + padding)
        constraintCBottom.constant   = h - 3.0 * smallSquareWidth - 2 * padding
        constraintCLeading.constant  = w3 + halfPad
        constraintCTrailing.constant = w3 + halfPad

        constraintDTop.constant      = 3.0 * (smallSquareWidth + padding)
        constraintDBottom.constant   = h - 4.0 * smallSquareWidth - 3.0 * padding
        constraintDLeading.constant  = w3 + halfPad
        constraintDTrailing.constant = w3 + halfPad

        constraintSummaryTop.constant      = 2 * (squareWidth + padding)
        constraintSummaryBottom.constant   = padding
        constraintSummaryLeading.constant  = padding
        constraintSummaryTrailing.constant = padding
    }
}
