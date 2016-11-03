//
//  ClockView.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ClockView: UIView {

    // MARK: - Propeties

    var showHub: Bool = true
    var showTicks: Bool = true
    var hub: Hub?

    var hours: Int = 9
    var hourHand: HourHand?

    var minutes: Int = 15
    var minuteHand: MinuteHand?

    var seconds: Int = 0
    var secondHand: SecondHand?

    var shouldUpdateSubviews: Bool = true
    let calendar   = Calendar.current

    var highlightColor = UIColor.white

    // MARK: - Functions

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()!
        ClockFace(context: context, rect: rect, highlightColor: highlightColor).draw()
    }

    override func layoutSubviews() {
        if shouldUpdateSubviews {
            let clockDiameter = min(frame.width, frame.height)
            let x: CGFloat = 0.0 - min(frame.height - frame.width, 0) / 2.0 //frame.midX - clockRadius
            let y: CGFloat = 0.0 - min(frame.width - frame.height, 0) / 2.0 //frame.midY - clockRadius
            let clockFrame = CGRect(x: x, y: y, width: clockDiameter, height: clockDiameter)

            // If refreshing the view, remove the old clock hands.
            if let _ = hourHand, let viewWithTag = viewWithTag(101) {
                viewWithTag.removeFromSuperview()
            }
            hourHand = HourHand(frame: clockFrame)
            addSubview(hourHand!)

            if let _ = minuteHand, let viewWithTag = viewWithTag(102) {
                viewWithTag.removeFromSuperview()
            }
            minuteHand = MinuteHand(frame: clockFrame)
            addSubview(minuteHand!)

            if let _ = secondHand, let viewWithTag = viewWithTag(103) {
                viewWithTag.removeFromSuperview()
            }
            secondHand = SecondHand(frame: clockFrame)
            addSubview(secondHand!)

            if let _ = hub, let viewWithTag = viewWithTag(104) {
                viewWithTag.removeFromSuperview()
            }
            hub = Hub(frame: clockFrame)
            addSubview(hub!)

            startClock()
            shouldUpdateSubviews = false
        }
    }

    ///  Starts the clock ticking (but delays the first tick so that it approximates with
    ///  the next whole second on the system clock).
    ///
    fileprivate func startClock() {
        let calendar   = Calendar.current
        let components = (calendar as NSCalendar).components([.nanosecond], from: Date())

        let dispatchTime = DispatchTime.now() + Double(Int64(1_000_000_000 - components.nanosecond!)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            Timer.scheduledTimer(timeInterval: 1.0,
                target: self,
                selector: #selector(ClockView.updateClock),
                userInfo: nil,
                repeats: true)
        }
    }

    func updateClock() {
        getCurrentTime()

        minuteHand!.rotateHandTo(degrees: degreesFrom(minutes: minutes, seconds: seconds))
        hourHand!.rotateHandTo(degrees: degreesFrom(hours: hours, minutes: minutes, seconds: seconds))
        secondHand!.rotateHandTo(degrees: degreesFrom(seconds: seconds))
    }

    fileprivate func getCurrentTime() {
        let components = (calendar as NSCalendar).components([.hour, .minute, .second], from: Date())
        hours   = components.hour!
        minutes = components.minute!
        seconds = components.second!
    }

    fileprivate func degreesFrom(hours: Int, minutes: Int, seconds: Int) -> Double {
        let degrees = Double(hours) * 30.0 + Double(minutes) / 2.0 + Double(seconds) / 120.0
        return degrees
    }

    fileprivate func degreesFrom(minutes: Int, seconds: Int) -> Double {
        let degrees = Double(minutes) * 6.0 + Double(seconds) / 10.0
        return degrees
    }

    fileprivate func degreesFrom(seconds: Int) -> Double {
        // (The + 6 below is "delay" the hand by one second
        //  so that it arrives at the exact time rather than departs.)
        let degrees = Double(seconds * 6) + 6
        return degrees
    }
}
