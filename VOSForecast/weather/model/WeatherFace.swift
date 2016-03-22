//
//  WeatherFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherFace: InstrumentFace {

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
        let maxX = square.maxX - gap
        CGContextMoveToPoint(context, minX, square.midY)
        CGContextAddLineToPoint(context, maxX, square.midY)

        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextSetAlpha(context, borderAlpha)
        CGContextSetLineWidth(context, borderWidth)
        CGContextStrokePath(context)
    }
}