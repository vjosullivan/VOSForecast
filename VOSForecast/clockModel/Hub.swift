//
//  Hub.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 26/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class Hub: UIView {

    let hubColor: UIColor
    let hubAlpha: CGFloat
    let hubRadius: CGFloat

    override init(frame: CGRect) {
        hubRadius = 0.02
        hubColor  = UIColor.whiteColor()
        hubAlpha  = 1.0
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {

        let clockRadius = min(rect.width, rect.height) / 2.0
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let circlePath = UIBezierPath(arcCenter: centre, radius: hubRadius * clockRadius, startAngle: 0.0, endAngle: 6.3, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath

        //change the fill color
        shapeLayer.fillColor   = UIColor.lightGrayColor().CGColor
        shapeLayer.strokeColor = UIColor.grayColor().CGColor
        shapeLayer.lineWidth = 0.0
        
        layer.addSublayer(shapeLayer)
    }
}