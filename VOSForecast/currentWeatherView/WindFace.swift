//
//  WindFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WindFace: UIView {

    let windTicks: WindTicks
    let letters: WindLetters
    let context: CGContextRef
    let rect: CGRect

    var borderColor: UIColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var borderAlpha: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0

    var faceBackgroundColor = UIColor(red: 85.0 / 255.0, green: 85.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    var faceBackgroundAlpha: CGFloat = 1.0

    var digitFont: UIFont    = UIFont(name: "HelveticaNeue", size: 20)!
    var digitColor: UIColor  = UIColor.whiteColor()
    var digitOuterRadius: CGFloat = 0.99

    init(context: CGContextRef, rect: CGRect) {
        self.context   = context
        self.rect      = rect
        self.windTicks = WindTicks(rawValue: NSUserDefaults.readInt(key: "WindTicks", defaultValue: WindTicks.ThirtyTwo.rawValue))!
        self.letters   = WindLetters(rawValue: NSUserDefaults.readInt(key: "WindLetters", defaultValue: WindLetters.Eight.rawValue))!
        super.init(frame: rect)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func draw() {
        drawClockFace()
        drawClockBorder()
        drawWindLetters()
        drawTicks()
    }

    private func drawClockFace() {
        CGContextAddEllipseInRect(context, squareRect(rect));
        CGContextSetFillColorWithColor(context, faceBackgroundColor.CGColor);
        CGContextSetAlpha(context, faceBackgroundAlpha);
        CGContextFillPath(context);
    }

    private func drawClockBorder() {
        CGContextAddEllipseInRect(context, squareRect(rect));
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetAlpha(context, borderAlpha);
        CGContextSetLineWidth(context, borderWidth);
        CGContextStrokePath(context);
    }

    ///  Returns a square `CGRect`, centered on the given `CGRect`.
    ///
    private func squareRect(rect: CGRect) -> CGRect {
        let clockDiameter = min(rect.width, rect.height)
        let clockRadius   = clockDiameter / 2.0
        return CGRectMake(
            rect.origin.x + (rect.width  / 2.0) - clockRadius + borderWidth / 2.0,
            rect.origin.y + (rect.height / 2.0) - clockRadius + borderWidth / 2.0,
            clockDiameter - borderWidth,
            clockDiameter - borderWidth)
    }

    private func drawTicks() {
        let degToRads = M_PI / 180.0
        if windTicks != WindTicks.None {
            for index in 0..<64 {
                var tick: TickMark?
                if index == 0 && windTicks.rawValue >= WindTicks.One.rawValue {
                    tick = TickZero()
                } else if index % 4 == 0 && windTicks.rawValue >= WindTicks.Four.rawValue {
                    tick = TickFifteen()
                } else if index % 8 == 0 && windTicks.rawValue >= WindTicks.Eight.rawValue {
                    tick = TickFive()
                } else if index % 16 == 0 && windTicks.rawValue >= WindTicks.Sixteen.rawValue {
                    tick = TickOne()
                } else if index % 32 == 0 && windTicks.rawValue >= WindTicks.ThirtyTwo.rawValue {
                    tick = TickOne()
                } else if index % 64 == 0 && windTicks.rawValue >= WindTicks.SixtyFour.rawValue {
                    tick = TickOne()
                }
                let tickAngleRadians  = CGFloat(5.625 * (Double(index) + 48) * degToRads)
                if let tick = tick {
                    tick.draw(context, angle: tickAngleRadians, rect: rect)
                }
            }
        }
    }

    private func drawWindLetters() {
        // Save the context
        CGContextSaveGState(context)
        CGContextTranslateCTM (context, rect.width / 2, rect.height / 2)
        CGContextScaleCTM (context, 1, -1)
        let radius = 0.8 * min(rect.width, rect.height) / 2.0
        let writer = Circlewriter(context: context, radius: radius, textOrientation: .Upright)
        switch letters {
        case .Sixteen, .ThirtyTwo:
            writer.write(["NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"], lastWord: .OnTop)
        case .Eight:
            writer.write(["NE", "E", "SE", "S", "SW", "W", "NW", "N"], lastWord: .OnTop)
        case .Four:
            writer.write(["E", "S", "W", "N"], lastWord: .OnTop)
        case .One:
            writer.write(["N"], lastWord: .OnTop)
        case .None:
            break
        }
        // Restore the context
        CGContextRestoreGState(context)
    }
}

// MARK: - Associated enums

enum WindLetters: Int {
    case None      = 0
    case One       = 1
    case Four      = 2
    case Eight     = 3
    case Sixteen   = 4
    case ThirtyTwo = 5
}

enum WindTicks: Int {
    case None      = 0
    case One       = 1
    case Four      = 2
    case Eight     = 3
    case Sixteen   = 4
    case ThirtyTwo = 5
    case SixtyFour = 6
}
