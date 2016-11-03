//
//  InstrumentFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 19/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class InstrumentFace {

    internal let context: CGContext
    internal let rect: CGRect
    internal let square: CGRect

    internal let borderColor: UIColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    internal let borderAlpha: CGFloat = 1.0
    internal let borderWidth: CGFloat = 1.0

    internal let faceBackgroundColor = AppColor.faceColor
    internal let faceBackgroundAlpha: CGFloat = 1.0

    init(context: CGContext, rect: CGRect) {
        self.context = context
        self.rect    = rect

        // Create a square that fits in the given rectangle.
        let side = min(rect.width, rect.height)
        square = CGRect(
            x: (rect.width  - side) / 2.0,
            y: (rect.height - side) / 2.0,
            width: side,
            height: side)
    }

    func draw() {
        drawFace()
        drawBorder()
    }

    fileprivate func drawFace() {
        context.move(to: CGPoint(x: square.midX, y: square.minY))
        context.addCurve(to: CGPoint(x: square.maxX, y: square.midY), control1: CGPoint(x: square.maxX, y: square.minY), control2: CGPoint(x: square.maxX, y: square.minY))
        context.addCurve(to: CGPoint(x: square.midX, y: square.maxY), control1: CGPoint(x: square.maxX, y: square.maxY), control2: CGPoint(x: square.maxX, y: square.maxY))
        context.addCurve(to: CGPoint(x: square.minX, y: square.midY), control1: CGPoint(x: square.minX, y: square.maxY), control2: CGPoint(x: square.minX, y: square.maxY))
        context.addCurve(to: CGPoint(x: square.midX, y: square.minY), control1: CGPoint(x: square.minX, y: square.minY), control2: CGPoint(x: square.minX, y: square.minY))
//        CGContextAddCurveToPoint(context, square.maxX, square.minY, square.maxX, square.minY, square.maxX, square.midY)
//        CGContextAddCurveToPoint(context, square.maxX, square.maxY, square.maxX, square.maxY, square.midX, square.maxY)
//        CGContextAddCurveToPoint(context, square.minX, square.maxY, square.minX, square.maxY, square.minX, square.midY)
//        CGContextAddCurveToPoint(context, square.minX, square.minY, square.minX, square.minY, square.midX, square.minY)
        context.setFillColor(faceBackgroundColor.cgColor)
        context.setAlpha(faceBackgroundAlpha)
        context.fillPath()
    }

    fileprivate func drawBorder() {

        context.move(to: CGPoint(x: square.midX, y: square.minY))
        context.addCurve(to: CGPoint(x: square.maxX, y: square.midY), control1: CGPoint(x: square.maxX, y: square.minY), control2: CGPoint(x: square.maxX, y: square.minY))
        context.addCurve(to: CGPoint(x: square.midX, y: square.maxY), control1: CGPoint(x: square.maxX, y: square.maxY), control2: CGPoint(x: square.maxX, y: square.maxY))
        context.addCurve(to: CGPoint(x: square.minX, y: square.midY), control1: CGPoint(x: square.minX, y: square.maxY), control2: CGPoint(x: square.minX, y: square.maxY))
        context.addCurve(to: CGPoint(x: square.midX, y: square.minY), control1: CGPoint(x: square.minX, y: square.minY), control2: CGPoint(x: square.minX, y: square.minY))
//        CGContextAddCurveToPoint(context, square.maxX, square.minY, square.maxX, square.minY, square.maxX, square.midY)
//        CGContextAddCurveToPoint(context, square.maxX, square.maxY, square.maxX, square.maxY, square.midX, square.maxY)
//        CGContextAddCurveToPoint(context, square.minX, square.maxY, square.minX, square.maxY, square.minX, square.midY)
//        CGContextAddCurveToPoint(context, square.minX, square.minY, square.minX, square.minY, square.midX, square.minY)
        context.setStrokeColor(borderColor.cgColor)
        context.setAlpha(borderAlpha)
        context.setLineWidth(borderWidth)
        context.strokePath()
    }
}
