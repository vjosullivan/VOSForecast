//
//  TemperatureFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class TemperatureFace: InstrumentFace {

    override init(context: CGContextRef, rect: CGRect) {
        super.init(context: context, rect: rect)
    }

    override func draw() {
        super.draw()
        drawQuarterLines()
    }

    private func drawQuarterLines() {
        let gap = square.size.width * 0.1
        let minX = square.minX + gap
        let midX1 = square.midX - gap
        let midX2 = square.midX + gap
        let maxX = square.maxX - gap
        let minY = square.minY + gap
        let midY1 = square.midY - gap
        let midY2 = square.midY + gap
        let maxY = square.maxY - gap
        CGContextMoveToPoint(context, square.midX, midY1)
        CGContextAddLineToPoint(context, square.midX, minY)
        CGContextMoveToPoint(context, midX2, square.midY)
        CGContextAddLineToPoint(context, maxX, square.midY)
        CGContextMoveToPoint(context, square.midX, midY2)
        CGContextAddLineToPoint(context, square.midX, maxY)
        CGContextMoveToPoint(context, midX1, square.midY)
        CGContextAddLineToPoint(context, minX, square.midY)

        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextSetAlpha(context, borderAlpha)
        CGContextSetLineWidth(context, borderWidth)
        CGContextStrokePath(context)
    }

}