//
//  Hand.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import UIKit

class Hand: UIView {
    
    internal var color: UIColor = UIColor.white
    internal var borderColor: UIColor = UIColor.white
    internal var width: CGFloat = 0.0
    internal var length: CGFloat = 0.0
    internal var offsetLength: CGFloat = 0.0
    internal var shadowEnabled: Bool = false
    fileprivate  var clockFrame: CGRect = CGRect.null
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clockFrame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotateHandTo(degrees: Double) {
        let animations = {() in
            let radians = CGFloat(degrees * M_PI / 180.0)
            self.transform = CGAffineTransform(rotationAngle: radians)
        }

        //UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: animations, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: [], animations: animations, completion: nil)
    }
    
    override func draw(_ rect: CGRect) {
        // the frame needs to be drawn as if it is in a cartesian plane,
        // with the center of rotation at what is thought of as (0, 0) and
        // the far end to the top of the center, this way when we rotate
        // the view, it will look correct.

        let clockRadius = min(rect.midX, rect.midY)
        let xOffset = rect.midX - clockRadius
        let yOffset = rect.midY - clockRadius
        // point that is the top of the hand (closest to the edge of the clock)
        let top = CGPoint(x: xOffset + clockRadius, y: yOffset + clockRadius - length * clockRadius);
        // point at the bottom of the hand, a total distance offsetLength away from
        // the center of rotation.
        let bottom = CGPoint(x: xOffset + clockRadius, y: yOffset + clockRadius + offsetLength * clockRadius);

        let left  = CGPoint(x: xOffset + clockRadius + width, y: yOffset + clockRadius)
        let right = CGPoint(x: xOffset + clockRadius - width, y: yOffset + clockRadius)

        // draw the line from the bottom to the top that has line width self.width.
        let path = UIBezierPath()
        path.lineWidth = 1.0
        path.move(to: bottom)
        path.addLine(to: left)
        path.addLine(to: top)
        path.addLine(to: right)
        color.setFill()
        path.fill()
        path.close()
        borderColor.set() // sets teh color of the hand to be the color of the path
        path.stroke()
    }
}
