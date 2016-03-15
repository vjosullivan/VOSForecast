//
//  OtherFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class OtherFace {

    let context: CGContextRef
    let rect: CGRect

    var borderColor: UIColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var borderAlpha: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0

    var faceBackgroundColor = UIColor(red: 85.0 / 255.0, green: 85.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    var faceBackgroundAlpha: CGFloat = 1.0

    init(context: CGContextRef, rect: CGRect) {
        self.context   = context
        self.rect      = rect
    }

    func draw() {
        drawTemperatureFace()
        drawTemperatureBorder()
    }

    private func drawTemperatureFace() {
        CGContextAddEllipseInRect(context, squareRect(rect));
        CGContextSetFillColorWithColor(context, faceBackgroundColor.CGColor);
        CGContextSetAlpha(context, faceBackgroundAlpha);
        CGContextFillPath(context);
    }

    private func drawTemperatureBorder() {
        CGContextAddEllipseInRect(context, squareRect(rect));
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetAlpha(context, borderAlpha);
        CGContextSetLineWidth(context, borderWidth);
        CGContextStrokePath(context);
    }

    ///  Returns a square `CGRect`, centered on the given `CGRect`.
    ///
    private func squareRect(rect: CGRect) -> CGRect {
        let dialDiameter = min(rect.width, rect.height)
        let dialRadius   = dialDiameter / 2.0
        return CGRectMake(
            rect.origin.x + (rect.width  / 2.0) - dialRadius + borderWidth / 2.0,
            rect.origin.y + (rect.height / 2.0) - dialRadius + borderWidth / 2.0,
            dialDiameter - borderWidth,
            dialDiameter - borderWidth)
    }
}