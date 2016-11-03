//
//  WindView.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WindView: UIView {

    // MARK: - Propeties

    //var showHub: Bool = true
    var showTicks: Bool = true

    var windDirection: Double = 0.0 {
        didSet {
            updateCompass()
        }
    }
    var textColor: UIColor = UIColor.white

    var windHand: WindDirectionHand?

    var shouldUpdateSubviews: Bool = true
    let calendar   = Calendar.current

    // MARK: - Functions

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()!
        WindCompassFace(context: context, rect: rect).draw()
    }

    override func layoutSubviews() {
        if shouldUpdateSubviews {
            let compassDiameter = min(frame.width, frame.height)
            let x: CGFloat = 0.0 - min(frame.height - frame.width, 0) / 2.0 //frame.midX - clockRadius
            let y: CGFloat = 0.0 - min(frame.width - frame.height, 0) / 2.0 //frame.midY - clockRadius
            let clockFrame = CGRect(x: x, y: y, width: compassDiameter, height: compassDiameter)

            // If refreshing the view, remove the old wind hands.
            if let _ = windHand, let viewWithTag = viewWithTag(111) {
                viewWithTag.removeFromSuperview()
            }
            windHand = WindDirectionHand(frame: clockFrame, direction: 67.0)
            addSubview(windHand!)
            sendSubview(toBack: windHand!)

            //let hub = Hub(frame: clockFrame)
            //addSubview(hub)

            DispatchQueue.main.async {
                self.updateCompass()
            }
            shouldUpdateSubviews = false
        }
    }

    func updateCompass() {
        windHand!.rotateHand(degrees: windDirection + 180.0)
    }
}
