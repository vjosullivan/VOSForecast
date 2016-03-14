//
//  CurrentWindView.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class CurrentWindView: UIView {

    // MARK: - Propeties

    var showHub: Bool = true
    var showTicks: Bool = true

    var windDirection: Double = 0.0 {
        didSet {
            updateCompass()
        }
    }
    var windHand: WindHand?

    var shouldUpdateSubviews: Bool = true
    let calendar   = NSCalendar.currentCalendar()

    var delegate: ClockDelegate?

    // MARK: - Functions

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()!
        WindFace(context: context, rect: rect).draw()
    }

    override func layoutSubviews() {
        if shouldUpdateSubviews {
            let compassDiameter = min(frame.width, frame.height)
            let clockFrame = CGRect(x: 0, y: 0, width: compassDiameter, height: compassDiameter)

            // If refreshing the view, remove the old wind hands.
            if let _ = windHand, let viewWithTag = viewWithTag(111) {
                viewWithTag.removeFromSuperview()
            }
            windHand = WindHand(frame: clockFrame, direction: 67.0)
            addSubview(windHand!)
            sendSubviewToBack(windHand!)

            let hub = Hub(frame: clockFrame)
            addSubview(hub)

            dispatch_async(dispatch_get_main_queue()) {
                self.updateCompass()
            }
            shouldUpdateSubviews = false
        }
    }

    func updateCompass() {
        windHand!.rotateHand(degrees: windDirection + 180.0)
    }

    private func degreesFrom(seconds seconds: Int) -> Double {
        // (The + 6 below is "delay" the hand by one second
        //  so that it arrives at the exact time rather than departs.)
        let degrees = Double(seconds * 6) + 6
        return degrees
    }
}
