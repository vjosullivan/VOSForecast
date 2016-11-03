//
//  WeatherFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherFace: InstrumentFace {

    override init(context: CGContext, rect: CGRect) {
        super.init(context: context, rect: rect)
    }

    override func draw() {
        super.draw()
        drawQuarterLines()
    }

    fileprivate func drawQuarterLines() {
        let gap = square.size.width * 0.1
        let minX = square.minX + gap
        let maxX = square.maxX - gap
        context.move(to: CGPoint(x: minX, y: square.midY))
        context.addLine(to: CGPoint(x: maxX, y: square.midY))

        context.setStrokeColor(borderColor.cgColor)
        context.setAlpha(borderAlpha)
        context.setLineWidth(borderWidth)
        context.strokePath()
    }
}
