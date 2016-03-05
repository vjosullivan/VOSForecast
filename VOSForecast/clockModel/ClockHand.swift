//
//  ClockHand.swift
//  VOSClock
//
//  Created by Vincent O'Sullivan on 20/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import UIKit

class ClockHand: UIView {
    
    internal var color: UIColor = UIColor.whiteColor()
    internal var borderColor: UIColor = UIColor.whiteColor()
    internal var width: CGFloat = 0.0
    internal var length: CGFloat = 0.0
    internal var offsetLength: CGFloat = 0.0
    internal var shadowEnabled: Bool = false
    private(set) var degree: Double = 0.0
    private      var clockFrame: CGRect = CGRectNull
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clockFrame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(degree: Double) {
        self.degree = degree
        backgroundColor = UIColor.clearColor()
    }

    func rotateHand(degrees degrees: Double) {
        let animations = {() in
            let radians = CGFloat(degrees * M_PI / 180.0)
            self.transform = CGAffineTransformMakeRotation(radians)
        }

        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: animations, completion: nil)
    }
    
    override func drawRect(rect: CGRect) {
        // the frame needs to be drawn as if it is in a cartesian plane,
        // with the center of rotation at what is thought of as (0, 0) and
        // the far end to the top of the center, this way when we rotate
        // the view, it will look correct.

        let clockRadius = min(rect.midX, rect.midY)
        let xOffset = rect.midX - clockRadius
        let yOffset = rect.midY - clockRadius
        // point that is the top of the hand (closes to the edge of the clock)
        let top = CGPointMake(xOffset + clockRadius, yOffset + clockRadius - length * clockRadius);

        // point at the bottom of the hand, a total distance offsetLength away from
        // the center of rotation.
        let bottom = CGPointMake(xOffset + clockRadius, yOffset + clockRadius + offsetLength * clockRadius);

        let left  = CGPointMake(xOffset + clockRadius + width, yOffset + clockRadius)
        let right = CGPointMake(xOffset + clockRadius - width, yOffset + clockRadius)

        // draw the line from the bottom to the top that has line width self.width.
        let path = UIBezierPath()
        path.lineWidth = 1.0
        path.moveToPoint(bottom)
        path.addLineToPoint(left)
        path.addLineToPoint(top)
        path.addLineToPoint(right)
        color.setFill()
        path.fill()
        path.closePath()
        borderColor.set() // sets teh color of the hand to be the color of the path
        path.stroke()

        // roatate the view by the allotted amount
        rotateHand(degrees: degree)
    }
}
