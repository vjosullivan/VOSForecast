//
//  VOSClockView.swift
//  VOSClock
//
//  Created by Vincent O'Sullivan on 20/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class VOSClockView: UIView {

    // MARK: - Propeties

    var borderColor: UIColor = UIColor.whiteColor()
    var borderAlpha: CGFloat = 1.0
    var borderWidth: CGFloat = 3.0

    var faceBackgroundColor: UIColor = UIColor(red: 0.0, green: 25.0 / 255.0, blue: 102.0 / 255.0, alpha: 0.8)
    var faceBackgroundAlpha: CGFloat = 1.0

    var showDigits: Bool   = true
    var digitFont: UIFont    = UIFont(name: "HelveticaNeue-Thin", size: 17)!
    var digitColor: UIColor  = UIColor.whiteColor()
    var digitOuterRadius: CGFloat = 0.9
    
    var showHub: Bool = true
    
    var showTicks: Bool = true

    var hours: Int = 9
    var hourHand: HourHand?

    var minutes: Int = 15
    var minuteHand: MinuteHand?

    var seconds: Int = 0
    var secondHand: SecondHand?

    var shouldUpdateSubviews: Bool = true
    let calendar   = NSCalendar.currentCalendar()

    var delegate: VOSClockDelegate?

    // MARK: - Functions

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {

        let ctx = UIGraphicsGetCurrentContext()

        drawClockFace(ctx!, rect: rect)
        drawClockBorder(ctx!, rect: rect)
        if showDigits { drawDigits(rect) }
        if showTicks  { drawTicks(ctx!, rect: rect) }
    }

    override func layoutSubviews() {
        if shouldUpdateSubviews {

            let clockDiameter = min(frame.width, frame.height) * 0.75
            let clockRadius   = clockDiameter / 2.0
            let x = frame.midX - clockRadius
            let y = frame.midY - clockRadius
            let clockFrame = CGRect(x: x, y: y, width: clockDiameter, height: clockDiameter)
            hourHand = HourHand(frame: clockFrame)
            addSubview(hourHand!)

            minuteHand = MinuteHand(frame: clockFrame)
            addSubview(minuteHand!)

            secondHand = SecondHand(frame: clockFrame)
            addSubview(secondHand!)

            let hub = Hub(frame: clockFrame)
            addSubview(hub)
            
            startClock()
            shouldUpdateSubviews = false
        }
    }

    ///  Starts the clock ticking (but delays the first tick so that it approximates with
    ///  the next whole second on the system clock).
    ///
    private func startClock() {
        let calendar   = NSCalendar.currentCalendar()
        let components = calendar.components([.Nanosecond], fromDate: NSDate())

        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1_000_000_000 - components.nanosecond))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            NSTimer.scheduledTimerWithTimeInterval(1.0,
                target: self,
                selector:"updateClock",
                userInfo: nil,
                repeats: true)
        }
    }

    private func drawClockFace(ctx: CGContextRef, rect: CGRect) {
        CGContextAddEllipseInRect(ctx, clockRect(rect));
        CGContextSetFillColorWithColor(ctx, faceBackgroundColor.CGColor);
        CGContextSetAlpha(ctx, faceBackgroundAlpha);
        CGContextFillPath(ctx);
    }

    private func drawClockBorder(ctx: CGContextRef, rect: CGRect) {
        CGContextAddEllipseInRect(ctx, clockRect(rect));
        CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
        CGContextSetAlpha(ctx, borderAlpha);
        CGContextSetLineWidth(ctx, borderWidth);
        CGContextStrokePath(ctx);
    }
    
    ///  Returns a square `CGRect`, centered on the given `CGRect`.
    ///
    private func clockRect(rect: CGRect) -> CGRect {
        let clockDiameter = min(rect.width, rect.height)
        let clockRadius   = clockDiameter / 2.0
        return CGRectMake(
            rect.origin.x + (rect.width  / 2.0) - clockRadius + borderWidth / 2.0,
            rect.origin.y + (rect.height / 2.0) - clockRadius + borderWidth / 2.0,
            clockDiameter - borderWidth,
            clockDiameter - borderWidth)
    }
    
    private func drawTicks(ctx: CGContextRef, rect: CGRect) {
        let degToRads = M_PI / 180.0
        for index in 0..<60 {
            let tick: TickMark
            if index == 0 {
                tick = TickZero()
            } else if index % 15 == 0 {
                tick = TickFifteen()
            } else if index % 5 == 0 {
                tick = TickFive()
            } else {
                tick = TickOne()
            }
            let tickAngleRadians  = CGFloat((Double(6 * index) - 90.0) * degToRads)
            tick.draw(ctx, angle: tickAngleRadians, rect: rect)
        }
    }

    private func drawDigits(rect: CGRect) {
        let center = CGPointMake(rect.width / 2.0, rect.height / 2.0)
        let clockRadius = min(rect.width, rect.height) / 2.0
        let markingDistanceFromCenter = clockRadius * digitOuterRadius - digitFont.lineHeight / 4.0 - 15.0
        let offset = 4.0
        let hourAngle = 30 * M_PI / 180.0
        for hourIndex in 0..<12 {
            let hourNumber: NSString = "\((hourIndex + 1 < 10 ? " " : ""))\(hourIndex + 1)"
            let labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(cos(hourAngle * (Double(hourIndex) + offset) + M_PI))
            let labelY = center.y - (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(sin(hourAngle * (Double(hourIndex) + offset)))
            let box = CGRectMake(
                labelX - digitFont.lineHeight / 2.0,
                labelY - digitFont.lineHeight / 2.0,
                digitFont.lineHeight,
                digitFont.lineHeight)
            hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
        }
    }

    func updateClock() {
        getCurrentTime()

        minuteHand!.rotateHand(degrees: degreesFrom(minutes: minutes, seconds: seconds))
        hourHand!.rotateHand(degrees: degreesFrom(hours: hours, minutes: minutes, seconds: seconds))
        secondHand!.rotateHand(degrees: degreesFrom(seconds: seconds))
    }

    private func getCurrentTime() {
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: NSDate())
        hours   = components.hour
        minutes = components.minute
        seconds = components.second
    }

    private func radians(degrees degrees: Double) -> CGFloat {
        return CGFloat(degrees * M_PI / 180.0)
    }

    private func degreesFrom(hours hours: Int, minutes: Int, seconds: Int) -> Double {
        let degrees = Double(hours) * 30.0 + Double(minutes) / 2.0 + Double(seconds) / 120.0
        return degrees
    }

    private func degreesFrom(minutes minutes: Int, seconds: Int) -> Double {
        let degrees = Double(minutes) * 6.0 + Double(seconds) / 10.0
        return degrees
    }

    private func degreesFrom(seconds seconds: Int) -> Double {
        // (The + 6 below is "delay" the hand by one second
        //  so that it arrives at the exact time rather than departs.)
        let degrees = Double(seconds * 6) + 6
        return degrees
    }
}
