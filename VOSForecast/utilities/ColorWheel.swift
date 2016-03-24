//
//  ColorWheel.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 23/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

struct ColorWheel {

    private static let temperatureMin: CGFloat = -5.0
    private static let temperatureMax: CGFloat = +25.0
    private static let temperatureRange = temperatureMax - temperatureMin

    static func colorFor(temperature: Double, unit: String) -> UIColor {

        let centigrade = unit != "us" ? temperature : (temperature - 32.0) * 5 / 9
        let t = 1 - (CGFloat(centigrade) - temperatureMin) / temperatureRange
        let h: CGFloat
        switch true {
        case t < 0:
            h = 0.0
        case t > 1:
            h = 0.6667
        default:
            h = 0.6667 * t

        }
        let s: CGFloat = 0.55
        let b: CGFloat = 0.85
        return UIColor(hue: h, saturation: s, brightness: b, alpha: 1.0)
    }
}
