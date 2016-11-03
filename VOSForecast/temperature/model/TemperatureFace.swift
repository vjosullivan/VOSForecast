//
//  TemperatureFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class TemperatureFace: InstrumentFace {

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
        let midX1 = square.midX - gap
        let midX2 = square.midX + gap
        let maxX = square.maxX - gap
        let minY = square.minY + gap
        let midY1 = square.midY - gap
        let midY2 = square.midY + gap
        let maxY = square.maxY - gap
        context.move(to: CGPoint(x: square.midX, y: midY1))
        context.addLine(to: CGPoint(x: square.midX, y: minY))
        context.move(to: CGPoint(x: midX2, y: square.midY))
        context.addLine(to: CGPoint(x: maxX, y: square.midY))
        context.move(to: CGPoint(x: square.midX, y: midY2))
        context.addLine(to: CGPoint(x: square.midX, y: maxY))
        context.move(to: CGPoint(x: midX1, y: square.midY))
        context.addLine(to: CGPoint(x: minX, y: square.midY))

        context.setStrokeColor(borderColor.cgColor)
        context.setAlpha(borderAlpha)
        context.setLineWidth(borderWidth)
        context.strokePath()
    }

}
