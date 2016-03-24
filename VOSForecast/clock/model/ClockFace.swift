//
//  ClockAppearance.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

struct ClockKeys {
    static let tickmarks   = "clock.tickmarks"
    static let numeralType = "clock.numeraltype"
}

class ClockFace {

    let tickMarks: TickMarks
    let numeralType: NumeralType
    let context: CGContextRef
    let rect: CGRect

    var borderColor: UIColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var borderAlpha: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0

    var faceBackgroundColor = AppColor.faceColor
    var faceBackgroundAlpha: CGFloat = 1.0

    var digitFont: UIFont    = UIFont.systemFontOfSize(16)
    var digitColor: UIColor  = UIColor.whiteColor()
    var digitOuterRadius: CGFloat = 0.99

    var highlightColor = UIColor.whiteColor()

    init(context: CGContextRef, rect: CGRect, highlightColor: UIColor) {
        self.context     = context
        self.rect        = rect
        self.highlightColor = highlightColor

        self.tickMarks   = TickMarks(rawValue: NSUserDefaults.readInt(key: ClockKeys.tickmarks, defaultValue: TickMarks.Minutes.rawValue))!
        self.numeralType = NumeralType(rawValue: NSUserDefaults.readInt(key: ClockKeys.numeralType, defaultValue: NumeralType.Arabic.rawValue))!
    }

    func draw() {
        drawClockFace()
        drawClockBorder()
        switch numeralType {
        case .None:
            break
        case .Roman:
            drawRomanNumerals()
        case .Arabic:
            drawArabicNumerals()
        }
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
        if tickMarks != TickMarks.None {
            for index in 0..<60 {
                var tick: Tick?
                if index == 0 && tickMarks.rawValue >= TickMarks.TwelveOClock.rawValue {
                    tick = TickZero(color: highlightColor)
                } else if index % 15 == 0 && tickMarks.rawValue >= TickMarks.Quarters.rawValue {
                    tick = LargeTick()
                } else if index % 5 == 0 && tickMarks.rawValue >= TickMarks.Hours.rawValue {
                    tick = MediumTick()
                } else if tickMarks.rawValue >= TickMarks.Minutes.rawValue {
                    tick = SmallTick()
                }
                if let tick = tick {
                    let tickAngleRadians = CGFloat((Double(6 * index) - 90.0) * degToRads)
                    tick.draw(context, angle: tickAngleRadians, rect: rect)
                }
            }
        }
    }

    private func drawRomanNumerals() {
        // Save the context
        CGContextSaveGState(context)
        CGContextTranslateCTM (context, rect.width / 2, rect.height / 2)
        CGContextScaleCTM (context, 1, -1)
        let radius = 0.775 * min(rect.width, rect.height) / 2.0
        let writer = Circlewriter(context: context, radius: radius, font: digitFont)
        switch tickMarks {
        case .Minutes, .Hours:
            writer.write(["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"], lastWord: .OnTop)
        case .Quarters:
            writer.write(["III", "VI", "IX", "XII"], lastWord: .OnTop)
        case .TwelveOClock:
            writer.write(["XII"], lastWord: .OnTop)
        case .None:
            break
        }
        // Restore the context
        CGContextRestoreGState(context)
    }

    private func drawArabicNumerals() {
        let center = CGPointMake(rect.width / 2.0, rect.height / 2.0)
        let clockRadius = min(rect.width, rect.height) / 2.0
        let markingDistanceFromCenter = clockRadius * digitOuterRadius - digitFont.lineHeight / 4.0 - 15.0
        let offset = 4.0
        let hourAngle = 30 * M_PI / 180.0
        for hourIndex in 0..<12 {
            let hourNumber: NSString = "\((hourIndex + 1 < 10 ? " " : ""))\(hourIndex + 1)"
            let labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(cos(hourAngle * (Double(hourIndex) + offset) + M_PI))
            let labelY = center.y - (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(sin(hourAngle * (Double(hourIndex) + offset)))
            let box = CGRectMake(
                labelX - digitFont.lineHeight / 2.0,
                labelY - digitFont.lineHeight / 2.0,
                digitFont.lineHeight,
                digitFont.lineHeight)
            if (hourIndex + 1) % 12 == 0 && tickMarks == TickMarks.TwelveOClock {
                hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if (hourIndex + 1) % 3 == 0 && tickMarks == TickMarks.Quarters {
                hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if tickMarks == TickMarks.Hours || tickMarks == TickMarks.Minutes {
                hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            }
        }
    }
}

// MARK: - Associated enums

enum NumeralType: Int {
    case None   = 0
    case Roman  = 1
    case Arabic = 2
}

enum TickMarks: Int {
    case None         = 0
    case TwelveOClock = 1
    case Quarters     = 2
    case Hours        = 3
    case Minutes      = 4
}

