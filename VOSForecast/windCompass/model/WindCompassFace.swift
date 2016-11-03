//
//  WindFace.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

struct WindVaneKeys {
    static let tickCount = "windvane.tickcount"
    static let labelCount = "windvane.labelcount"
}

class WindCompassFace: InstrumentFace {

    fileprivate let windTicks: WindTicks
    fileprivate let letters: WindLetters

    fileprivate let digitFont  = UIFont(name: "HelveticaNeue", size: 66)!
    fileprivate let digitColor = UIColor.white
    fileprivate let digitRadius: CGFloat = 0.75

    override init(context: CGContext, rect: CGRect) {

        self.windTicks = WindTicks(rawValue: UserDefaults.readInt(key: WindVaneKeys.tickCount, defaultValue: WindTicks.sixtyFour.rawValue))!
        self.letters   = WindLetters(rawValue: UserDefaults.readInt(key: WindVaneKeys.labelCount, defaultValue: WindLetters.eight.rawValue))!

        super.init(context: context, rect: rect)
    }

    override func draw() {
        super.draw()
        drawWindLetters()
        drawTicks()
    }

    fileprivate func drawTicks() {
        let degToRads = M_PI / 180.0
        if windTicks != WindTicks.none {
            for index in 0..<64 {
                var tick: Tick?
                if index == 0 && windTicks.rawValue >= WindTicks.one.rawValue {
                    tick = TickZero()
                } else if index % 16 == 0 && windTicks.rawValue >= WindTicks.four.rawValue {
                    tick = LargeTick()
                } else if index % 8 == 0 && windTicks.rawValue >= WindTicks.eight.rawValue {
                    tick = MediumTick()
                } else if index % 4 == 0 && windTicks.rawValue >= WindTicks.sixteen.rawValue {
                    tick = MediumTick()
                } else if index % 2 == 0 && windTicks.rawValue >= WindTicks.thirtyTwo.rawValue {
                    tick = SmallTick()
                } else if windTicks.rawValue >= WindTicks.sixtyFour.rawValue {
                    tick = SmallTick()
                }
                let tickAngleRadians  = CGFloat(5.625 * (Double(index) + 48) * degToRads)
                if let tick = tick {
                    tick.draw(super.context, angle: tickAngleRadians, rect: super.rect)
                }
            }
        }
    }

    fileprivate func drawWindLetters() {
        // Save the context
        context.saveGState()
        context.translateBy (x: rect.width / 2, y: rect.height / 2)
        context.scaleBy (x: 1, y: -1)
        let font = UIFont.systemFont(ofSize: 10)
        let radius = digitRadius * min(rect.width, rect.height) / 2.0
        let writer = Circlewriter(context: context, radius: radius, font: font, textOrientation: .upright)
        switch letters {
        case .sixteen, .thirtyTwo:
            writer.write(["NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"], lastWord: .onTop)
        case .eight:
            writer.write(["NE", "E", "SE", "S", "SW", "W", "NW", "N"], lastWord: .onTop)
        case .four:
            writer.write(["E", "S", "W", "N"], lastWord: .onTop)
        case .one:
            writer.write(["N"], lastWord: .onTop)
        case .none:
            break
        }
        // Restore the context
        context.restoreGState()
    }
}

// MARK: - Associated enums

enum WindLetters: Int {
    case none      = 0
    case one       = 1
    case four      = 2
    case eight     = 3
    case sixteen   = 4
    case thirtyTwo = 5
}

enum WindTicks: Int {
    case none      = 0
    case one       = 1
    case four      = 2
    case eight     = 3
    case sixteen   = 4
    case thirtyTwo = 5
    case sixtyFour = 6
}
