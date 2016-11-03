//
//  AstrolabeView.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class AstrolabeView: UIView {

    // MARK: - Propeties

    var showHub: Bool = true
    var showTicks: Bool = true
    var hub: Hub?

    var hours: Int = 0
    var hourHand: AstrolabeHourHand?

    var minutes: Int = 15

    var seconds: Int = 0

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
        AstrolabeFace(context: context, rect: rect).draw()
    }

    override func layoutSubviews() {
        if shouldUpdateSubviews {
            let diameter = min(frame.width, frame.height)
            let x: CGFloat = 0.0 - min(frame.height - frame.width, 0) / 2.0
            let y: CGFloat = 0.0 - min(frame.width - frame.height, 0) / 2.0
            let astrolabeFrame = CGRect(x: x, y: y, width: diameter, height: diameter)

            // If refreshing the view, remove the old hands before displaying new ones.
            if let _ = hourHand, let viewWithTag = viewWithTag(101) {
                viewWithTag.removeFromSuperview()
            }
            hourHand = AstrolabeHourHand(frame: astrolabeFrame)
            addSubview(hourHand!)

            if let _ = hub, let viewWithTag = viewWithTag(104) {
                viewWithTag.removeFromSuperview()
            }
            hub = Hub(frame: astrolabeFrame)
            addSubview(hub!)

            startAstrolabe()
            shouldUpdateSubviews = false
        }
    }

    ///  Starts the astrolabe ticking (but delays the first tick so that it approximates with
    ///  the next whole second on the system clock).
    ///
    fileprivate func startAstrolabe() {
        let calendar   = Calendar.current
        let components = (calendar as NSCalendar).components([.nanosecond], from: Date())

        let dispatchTime = DispatchTime.now() + Double(Int64(1_000_000_000 - components.nanosecond!)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            Timer.scheduledTimer(timeInterval: 1.0,
                target: self,
                selector:#selector(AstrolabeView.updateAstrolabe),
                userInfo: nil,
                repeats: true)
        }
    }

    func updateAstrolabe() {
        getCurrentTime()

        hourHand!.rotateHandTo(degrees: degreesFrom(hours: hours, minutes: minutes, seconds: seconds))
    }

    fileprivate func getCurrentTime() {
        let components = (calendar as NSCalendar).components([.hour, .minute, .second], from: Date())
        hours   = components.hour!
        minutes = components.minute!
        seconds = components.second!
    }

    fileprivate func degreesFrom(hours: Int, minutes: Int, seconds: Int) -> Double {
        let degrees = Double(hours) * 15.0 + Double(minutes) / 4.0 + Double(seconds) / 240.0 + 180.0
        return degrees
    }
}
