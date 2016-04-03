//
//  WindDirectionHand.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import UIKit

class WindDirectionHand: UIView {

    internal var color: UIColor = UIColor.whiteColor()
    internal var borderColor: UIColor = UIColor.whiteColor()
    internal var width: CGFloat = 0.0
    internal var length: CGFloat = 0.0
    internal var offsetLength: CGFloat = 0.0
    internal var shadowEnabled: Bool = false

    let direction: CGFloat

    init(frame: CGRect, direction: CGFloat) {
        self.direction = direction
        super.init(frame: frame)

      //color           = UIColor(red: 144.0/255.0, green: 212.0/255.0, blue: 132.0/255.0, alpha: 0.33)
        color           = UIColor(red: 196.0/255.0, green: 36.0/255.0, blue: 58.0/255.0, alpha: 0.75)
        borderColor     = UIColor(red: 144.0/255.0, green: 212.0/255.0, blue: 132.0/255.0, alpha: 0.75)
        backgroundColor = UIColor.clearColor()
        alpha         = 1.0
        width         = 16.0
        length        = 0.95
        offsetLength  = 0.1
        shadowEnabled = false
        tag           = 111
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rotateHand(degrees degrees: Double) {
        let animations = {() in
            let radians = CGFloat(degrees * M_PI / 180.0)
            self.transform = CGAffineTransformMakeRotation(radians)
        }

        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: animations, completion: nil)
    }

    override func drawRect(rect: CGRect) {
        // the frame needs to be drawn as if it is in a cartesian plane,
        // with the center of rotation at what is thought of as (0, 0) and
        // the far end to the top of the center, this way when we rotate
        // the view, it will look correct.

        let compassRadius = min(rect.midX, rect.midY)
        let xOffset = rect.midX - compassRadius
        let yOffset = rect.midY - compassRadius
        // point that is the top of the hand (closest to the edge of the compass)
        let top = CGPointMake(xOffset + compassRadius, yOffset + compassRadius - length * compassRadius);
        let right1 = CGPointMake(xOffset + compassRadius + width / 2.0, yOffset + compassRadius - length * compassRadius + width / 2.0)
        let right2 = CGPointMake(xOffset + compassRadius + width / 2.0, yOffset + compassRadius + length * compassRadius)
        let left1  = CGPointMake(xOffset + compassRadius - width / 2.0, yOffset + compassRadius - length * compassRadius + width / 2.0)
        let left2  = CGPointMake(xOffset + compassRadius - width / 2.0, yOffset + compassRadius + length * compassRadius)
        let bottom = CGPointMake(xOffset + compassRadius,               yOffset + compassRadius + length * compassRadius - width / 2.0);


        // draw the line from the bottom to the top that has line width self.width.
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.moveToPoint(top)
        path.addLineToPoint(right1)
        path.addLineToPoint(right2)
        path.addLineToPoint(bottom)
        path.addLineToPoint(left2)
        path.addLineToPoint(left1)
        color.setFill()
        path.fill()
        path.closePath()
        borderColor.set() // sets teh color of the hand to be the color of the path
        path.stroke()
    }
}
