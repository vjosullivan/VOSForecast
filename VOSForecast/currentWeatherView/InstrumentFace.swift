//
//  InstrumentFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 19/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class InstrumentFace {

    internal let context: CGContextRef
    internal let rect: CGRect
    internal let square: CGRect

    internal let borderColor: UIColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    internal let borderAlpha: CGFloat = 1.0
    internal let borderWidth: CGFloat = 1.0

    internal let faceBackgroundColor = AppColour.faceColour
    internal let faceBackgroundAlpha: CGFloat = 1.0

    init(context: CGContextRef, rect: CGRect) {
        self.context = context
        self.rect    = rect

        // Create a square that fits in the given rectangle.
        let side = min(rect.width, rect.height)
        square = CGRectMake(
            (rect.width  - side) / 2.0,
            (rect.height - side) / 2.0,
            side,
            side)
    }

    func draw() {
        drawFace()
        drawBorder()
    }

    private func drawFace() {
        CGContextMoveToPoint(context, square.midX, square.minY)
        CGContextAddCurveToPoint(context, square.maxX, square.minY, square.maxX, square.minY, square.maxX, square.midY)
        CGContextAddCurveToPoint(context, square.maxX, square.maxY, square.maxX, square.maxY, square.midX, square.maxY)
        CGContextAddCurveToPoint(context, square.minX, square.maxY, square.minX, square.maxY, square.minX, square.midY)
        CGContextAddCurveToPoint(context, square.minX, square.minY, square.minX, square.minY, square.midX, square.minY)
        CGContextSetFillColorWithColor(context, faceBackgroundColor.CGColor)
        CGContextSetAlpha(context, faceBackgroundAlpha)
        CGContextFillPath(context)
    }

    private func drawBorder() {

        CGContextMoveToPoint(context, square.midX, square.minY)
        CGContextAddCurveToPoint(context, square.maxX, square.minY, square.maxX, square.minY, square.maxX, square.midY)
        CGContextAddCurveToPoint(context, square.maxX, square.maxY, square.maxX, square.maxY, square.midX, square.maxY)
        CGContextAddCurveToPoint(context, square.minX, square.maxY, square.minX, square.maxY, square.minX, square.midY)
        CGContextAddCurveToPoint(context, square.minX, square.minY, square.minX, square.minY, square.midX, square.minY)
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextSetAlpha(context, borderAlpha)
        CGContextSetLineWidth(context, borderWidth)
        CGContextStrokePath(context)
    }
}
