//
//  AstrolabeFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class AstrolabeFace {

    let tickMarks: AstrolabeTickMarks
    let numerals: Numerals
    let context: CGContextRef
    let rect: CGRect

    var borderColor: UIColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var borderAlpha: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0

    var faceBackgroundColor = UIColor(red: 85.0 / 255.0, green: 85.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    var faceBackgroundAlpha: CGFloat = 1.0

    var digitFont: UIFont    = UIFont.systemFontOfSize(16)
    var digitColor: UIColor  = UIColor.whiteColor()
    var digitOuterRadius: CGFloat = 0.99

    init(context: CGContextRef, rect: CGRect) {
        self.context   = context
        self.rect      = rect
        self.tickMarks = AstrolabeTickMarks(rawValue: NSUserDefaults.readInt(key: "astrolabe.tickmarks", defaultValue: TickMarks.Minutes.rawValue))!
        self.numerals  = Numerals(rawValue: NSUserDefaults.readInt(key: "astrolabe.numerals", defaultValue: Numerals.Arabic.rawValue))!
    }

    func draw() {
        drawClockFace()
        drawClockBorder()
        switch numerals {
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
        if tickMarks != AstrolabeTickMarks.None {
            for index in 0..<60 {
                var tick: TickMark?
                if index % 24 == 0 && tickMarks.rawValue >= AstrolabeTickMarks.TwentyFourths.rawValue {
                    tick = TickFive()
                } else if index % 12 == 0 && tickMarks.rawValue >= AstrolabeTickMarks.Twelfths.rawValue {
                    tick = TickFive()
                } else if index % 8 == 0 && tickMarks.rawValue >= AstrolabeTickMarks.Eights.rawValue {
                    tick = TickFive()
                } else if index % 4 == 0 && tickMarks.rawValue >= AstrolabeTickMarks.Quarters.rawValue {
                    tick = TickFifteen()
                }
                let tickAngleRadians  = CGFloat((Double(6 * index) - 90.0) * degToRads)
                if let tick = tick {
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
        case .TwentyFourths:
            writer.write([
                "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII",
                "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XI", "XX", "XXI", "XXII", "XXIII", "XXIV"], lastWord: .OnTop)
        case .Twelfths:
            writer.write(["II", "IV", "VI", "VIII", "X", "XII", "XIV", "XVI", "XVIII", "XX", "XXII", "XXIV"], lastWord: .OnTop)
        case .Eights:
            writer.write(["III", "VI", "IX", "XII", "XV", "XVIII", "XXI", "XIV"], lastWord: .OnTop)
        case .Quarters:
            writer.write(["VI", "XII", "XVIII", "XIV"], lastWord: .OnTop)
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
            if (hourIndex + 1) % 12 == 0 && tickMarks == AstrolabeTickMarks.Quarters {
                hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if (hourIndex + 1) % 3 == 0 && tickMarks == AstrolabeTickMarks.Eights {
                hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if tickMarks == AstrolabeTickMarks.Twelfths {
                hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if tickMarks == AstrolabeTickMarks.TwentyFourths {
                hourNumber.drawInRect(box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            }
        }
    }
}

enum AstrolabeTickMarks: Int {
    case None          = 0
    case Quarters      = 1
    case Eights        = 2
    case Twelfths      = 3
    case TwentyFourths = 4
}

