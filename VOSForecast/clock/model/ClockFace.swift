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

    var highlightColor = UIColor.white

    init(context: CGContext, rect: CGRect, highlightColor: UIColor) {
        self.context     = context
        self.rect        = rect
        self.highlightColor = highlightColor

        self.tickMarks   = TickMarks(rawValue: UserDefaults.readInt(key: ClockKeys.tickmarks, defaultValue: TickMarks.minutes.rawValue))!
        self.numeralType = NumeralType(rawValue: UserDefaults.readInt(key: ClockKeys.numeralType, defaultValue: NumeralType.arabic.rawValue))!
    }

    func draw() {
        drawClockFace()
        drawClockBorder()
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

    fileprivate func drawClockFace() {
        context.addEllipse(in: squareRect(rect));
        context.setFillColor(faceBackgroundColor.cgColor);
        context.setAlpha(faceBackgroundAlpha);
        context.fillPath();
    }

    fileprivate func drawClockBorder() {
        context.addEllipse(in: squareRect(rect));
        context.setStrokeColor(borderColor.cgColor);
        context.setAlpha(borderAlpha);
        context.setLineWidth(borderWidth);
        context.strokePath();
    }

    ///  Returns a square `CGRect`, centered on the given `CGRect`.
    ///
    fileprivate func squareRect(_ rect: CGRect) -> CGRect {
        let clockDiameter = min(rect.width, rect.height)
        let clockRadius   = clockDiameter / 2.0
        return CGRect(
            x: rect.origin.x + (rect.width  / 2.0) - clockRadius + borderWidth / 2.0,
            y: rect.origin.y + (rect.height / 2.0) - clockRadius + borderWidth / 2.0,
            width: clockDiameter - borderWidth,
            height: clockDiameter - borderWidth)
    }

    fileprivate func drawTicks() {
        let degToRads = M_PI / 180.0
        if tickMarks != TickMarks.none {
            for index in 0..<60 {
                var tick: Tick?
                if index == 0 && tickMarks.rawValue >= TickMarks.twelveOClock.rawValue {
                    tick = TickZero(color: highlightColor)
                } else if index % 15 == 0 && tickMarks.rawValue >= TickMarks.quarters.rawValue {
                    tick = LargeTick()
                } else if index % 5 == 0 && tickMarks.rawValue >= TickMarks.hours.rawValue {
                    tick = MediumTick()
                } else if tickMarks.rawValue >= TickMarks.minutes.rawValue {
                    tick = SmallTick()
                }
                if let tick = tick {
                    let tickAngleRadians = CGFloat((Double(6 * index) - 90.0) * degToRads)
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
        case .minutes, .hours:
            writer.write(["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"], lastWord: .onTop)
        case .quarters:
            writer.write(["III", "VI", "IX", "XII"], lastWord: .onTop)
        case .twelveOClock:
            writer.write(["XII"], lastWord: .onTop)
        case .none:
            break
        }
        // Restore the context
        context.restoreGState()
    }

    fileprivate func drawArabicNumerals() {
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        let clockRadius = min(rect.width, rect.height) / 2.0
        let markingDistanceFromCenter = clockRadius * digitOuterRadius - digitFont.lineHeight / 4.0 - 15.0
        let offset = 4.0
        let hourAngle = 30 * M_PI / 180.0
        for hourIndex in 0..<12 {
            let hourNumber = "\((hourIndex + 1 < 10 ? " " : ""))\(hourIndex + 1)"
            let labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(cos(hourAngle * (Double(hourIndex) + offset) + M_PI))
            let labelY = center.y - (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(sin(hourAngle * (Double(hourIndex) + offset)))
            let box = CGRect(
                x: labelX - digitFont.lineHeight / 2.0,
                y: labelY - digitFont.lineHeight / 2.0,
                width: digitFont.lineHeight,
                height: digitFont.lineHeight)
            if (hourIndex + 1) % 12 == 0 && tickMarks == TickMarks.twelveOClock {
                hourNumber.draw(in: box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if (hourIndex + 1) % 3 == 0 && tickMarks == TickMarks.quarters {
                hourNumber.draw(in: box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            } else if tickMarks == TickMarks.hours || tickMarks == TickMarks.minutes {
                hourNumber.draw(in: box, withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            }
        }
    }
}

// MARK: - Associated enums

enum NumeralType: Int {
    case none   = 0
    case roman  = 1
    case arabic = 2
}

enum TickMarks: Int {
    case none         = 0
    case twelveOClock = 1
    case quarters     = 2
    case hours        = 3
    case minutes      = 4
}

