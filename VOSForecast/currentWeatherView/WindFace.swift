//
//  WindFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WindFace: InstrumentFace {

    private let windTicks: WindTicks
    private let letters: WindLetters

    private let digitFont  = UIFont(name: "HelveticaNeue", size: 66)!
    private let digitColor = UIColor.whiteColor()
    private let digitRadius: CGFloat = 0.75

    override init(context: CGContextRef, rect: CGRect) {

        self.windTicks = WindTicks(rawValue: NSUserDefaults.readInt(key: "WindTicks", defaultValue: WindTicks.SixtyFour.rawValue))!
        self.letters   = WindLetters(rawValue: NSUserDefaults.readInt(key: "WindLetters", defaultValue: WindLetters.Eight.rawValue))!

        super.init(context: context, rect: rect)
    }

    override func draw() {
        super.draw()
        drawWindLetters()
        drawTicks()
    }

    private func drawTicks() {
        let degToRads = M_PI / 180.0
        if windTicks != WindTicks.None {
            for index in 0..<64 {
                var tick: TickMark?
                if index == 0 && windTicks.rawValue >= WindTicks.One.rawValue {
                    tick = TickZero()
                } else if index % 16 == 0 && windTicks.rawValue >= WindTicks.Four.rawValue {
                    tick = TickFifteen()
                } else if index % 8 == 0 && windTicks.rawValue >= WindTicks.Eight.rawValue {
                    tick = TickFive()
                } else if index % 4 == 0 && windTicks.rawValue >= WindTicks.Sixteen.rawValue {
                    tick = TickEight()
                } else if index % 2 == 0 && windTicks.rawValue >= WindTicks.ThirtyTwo.rawValue {
                    tick = TickOne()
                } else if windTicks.rawValue >= WindTicks.SixtyFour.rawValue {
                    tick = TickOne()
                }
                let tickAngleRadians  = CGFloat(5.625 * (Double(index) + 48) * degToRads)
                if let tick = tick {
                    tick.draw(super.context, angle: tickAngleRadians, rect: super.rect)
                }
            }
        }
    }

    private func drawWindLetters() {
        // Save the context
        CGContextSaveGState(context)
        CGContextTranslateCTM (context, rect.width / 2, rect.height / 2)
        CGContextScaleCTM (context, 1, -1)
        let font = UIFont.systemFontOfSize(10)
        let radius = digitRadius * min(rect.width, rect.height) / 2.0
        let writer = Circlewriter(context: context, radius: radius, font: font, textOrientation: .Upright)
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
