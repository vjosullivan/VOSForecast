//
//  AstrolabeFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

struct AstrolabeKeys {
    static let tickmarks   = "astrolabe.tickmarks"
    static let numeralType = "astrolabe.numeraltype"
}

class AstrolabeFace {

    let tickMarks: AstrolabeTickMarks
    let numeralType: NumeralType
    let context: CGContext
    let rect: CGRect

    var borderColor: UIColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var borderAlpha: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0

    var faceBackgroundColor = AppColor.faceColor
    var faceBackgroundAlpha: CGFloat = 1.0

    var digitFont: UIFont    = UIFont.systemFont(ofSize: 16)
    var digitColor: UIColor  = UIColor.white
    var digitOuterRadius: CGFloat = 0.99

    init(context: CGContext, rect: CGRect) {
        self.context     = context
        self.rect        = rect
        self.tickMarks   = AstrolabeTickMarks(rawValue: UserDefaults.readInt(key: AstrolabeKeys.tickmarks, defaultValue: TickMarks.minutes.rawValue))!
        self.numeralType = NumeralType(rawValue: UserDefaults.readInt(key: AstrolabeKeys.numeralType, defaultValue: NumeralType.arabic.rawValue))!
    }

    func draw() {
        drawAstrolabeFace()
        drawAstrolabeBorder()
        switch numeralType {
        case .none:
            break
        case .roman:
            drawRomanNumerals()
        case .arabic:
            drawArabicNumerals()
        }
        drawTicks()
    }

    fileprivate func drawAstrolabeFace() {
        context.addEllipse(in: squareRect(rect));
        context.setFillColor(faceBackgroundColor.cgColor);
        context.setAlpha(faceBackgroundAlpha);
        context.fillPath();
    }

    fileprivate func drawAstrolabeBorder() {
        context.addEllipse(in: squareRect(rect));
        context.setStrokeColor(borderColor.cgColor);
        context.setAlpha(borderAlpha);
        context.setLineWidth(borderWidth);
        context.strokePath();
    }

    ///  Returns a square `CGRect`, centered on the given `CGRect`.
    ///
    fileprivate func squareRect(_ rect: CGRect) -> CGRect {
        let diameter = min(rect.width, rect.height)
        let radius   = diameter / 2.0
        return CGRect(
            x: rect.origin.x + (rect.width  / 2.0) - radius + borderWidth / 2.0,
            y: rect.origin.y + (rect.height / 2.0) - radius + borderWidth / 2.0,
            width: diameter - borderWidth,
            height: diameter - borderWidth)
    }

    fileprivate func drawTicks() {
        let degToRads = M_PI / 180.0
        if tickMarks != AstrolabeTickMarks.none {
            for index in 0..<24 {
                var tick: Tick?
                if index % 6 == 0 && tickMarks.rawValue == AstrolabeTickMarks.quarters.rawValue {
                    tick = MediumTick()
                } else if index % 3 == 0 && tickMarks.rawValue == AstrolabeTickMarks.eights.rawValue {
                    tick = MediumTick()
                } else if index % 2 == 0 && tickMarks.rawValue == AstrolabeTickMarks.twelfths.rawValue {
                    tick = MediumTick()
                } else if tickMarks.rawValue == AstrolabeTickMarks.twentyFourths.rawValue {
                    tick = LargeTick()
                }
                if let tick = tick {
                    let tickAngleRadians = CGFloat((Double(15 * index) - 90.0) * degToRads)
                    tick.draw(context, angle: tickAngleRadians, rect: rect)
                }
            }
        }
    }

    fileprivate func drawRomanNumerals() {
        // Save the context
        context.saveGState()
        context.translateBy (x: rect.width / 2, y: rect.height / 2)
        context.scaleBy (x: 1, y: -1)
        let radius = 0.775 * min(rect.width, rect.height) / 2.0
        let writer = Circlewriter(context: context, radius: radius, font: digitFont)
        switch tickMarks {
        case .twentyFourths:
            writer.write([
                "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII",
                "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI", "XXII", "XXIII", "XXIV"], lastWord: .onBottom)
        case .twelfths:
            writer.write(["II", "IV", "VI", "VIII", "X", "XII", "XIV", "XVI", "XVIII", "XX", "XXII", "XXIV"], lastWord: .onBottom)
        case .eights:
            writer.write(["III", "VI", "IX", "XII", "XV", "XVIII", "XXI", "XIV"], lastWord: .onBottom)
        case .quarters:
            writer.write(["VI", "XII", "XVIII", "XIV"], lastWord: .onBottom)
        case .none:
            break
        }
        // Restore the context
        context.restoreGState()
    }

    fileprivate func drawArabicNumerals() {
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        let radius = min(rect.width, rect.height) / 2.0
        let markingDistanceFromCenter = radius * digitOuterRadius - digitFont.lineHeight / 4.0 - 15.0
        let offset = 4.0
        let hourAngle = 15 * M_PI / 180.0
        for hourIndex in 0..<24 {
            let hourNumber = "\((hourIndex + 1 < 10 ? " " : ""))\(hourIndex + 1)"
            let labelX = center.x - (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(cos(hourAngle * (Double(hourIndex) + offset) - 3 * M_PI / 4))
            let labelY = center.y - (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(sin(hourAngle * (Double(hourIndex) + offset) - 3 * M_PI / 4))
            let box = CGRect(
                x: labelX - digitFont.lineHeight / 2.0,
                y: labelY - digitFont.lineHeight / 2.0,
                width: digitFont.lineHeight * 1.05,
                height: digitFont.lineHeight)
            if (hourIndex + 1) % 6 == 0 && tickMarks == AstrolabeTickMarks.quarters {
                hourNumber.draw(in: box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if (hourIndex + 1) % 3 == 0 && tickMarks == AstrolabeTickMarks.eights {
                hourNumber.draw(in: box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if (hourIndex + 1) % 2 == 0 && tickMarks == AstrolabeTickMarks.twelfths {
                hourNumber.draw(in: box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if tickMarks == AstrolabeTickMarks.twentyFourths {
                hourNumber.draw(in: box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            }
        }
    }
}

enum AstrolabeTickMarks: Int {
    case none          = 0
    case quarters      = 1
    case eights        = 2
    case twelfths      = 3
    case twentyFourths = 4
}

