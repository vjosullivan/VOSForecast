//
//  Tick.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class Tick {
    
    // MARK: - Properties
    
    let color: UIColor
    let alpha: CGFloat
    
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let width: CGFloat
    let degToRads = M_PI / 180.0

    // MARK: - Functions
    
    init(color: UIColor, alpha: CGFloat, innerRadius: CGFloat, outerRadius: CGFloat, width: CGFloat) {
        self.color = color
        self.alpha = alpha
        
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.width = width
    }
    
    func draw(_ ctx: CGContext, angle: CGFloat, rect: CGRect) {
        let clockRadius = min(rect.midX, rect.midY)
        let xOffset = rect.width / 2.0 - clockRadius
        let yOffset = rect.height / 2.0 - clockRadius
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        
        let p1 = CGPoint(
            x: xOffset + clockRadius + (innerRadius * clockRadius) * cosAngle,
            y: yOffset + clockRadius + (innerRadius * clockRadius) * sinAngle)
        let p2 = CGPoint(
            x: xOffset + clockRadius + (outerRadius * clockRadius) * cosAngle,
            y: yOffset + clockRadius + (outerRadius * clockRadius) * sinAngle)
        
        let shapeLayer = CAShapeLayer()
        let path      = UIBezierPath()
        shapeLayer.path = path.cgPath
        path.lineWidth = width
        path.move(to: p1)
        path.addLine(to: p2)
        path.lineCapStyle = CGLineCap.round
        color.set()
        
        path.stroke(with: CGBlendMode.normal, alpha: alpha)
    }
}
