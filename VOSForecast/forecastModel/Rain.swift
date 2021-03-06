//
//  Rain.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct Rain {

    // US AMS definitions of limits of rain intensity in mm/hr
    static let dryUS           = (rate:    0.0, name: "Dry")
    static let lightRainUS     = (rate:    2.5, name: "Light")
    static let moderateRainUS  = (rate:    7.6, name: "Moderate")
    static let heavyRainUS     = (rate:   50.0, name: "Heavy")
    static let violentRainUS   = (rate: 1000.0, name: "Violent")

    // UK Met. Office definitions of limits of rain intensity in mm/hr.
    static let dryUK          = (rate:    0.0, name: "Dry")
    static let slightRainUK   = (rate:    2.0, name: "Slight")
    static let moderateRainUK = (rate:   10.0, name: "Moderate")
    static let heavyRainUK    = (rate:   50.0, name: "Heavy")
    static let violentRainUK  = (rate: 1000.0, name: "Violent")

    ///  Returns the appropriate term for the rate of rainfall.
    ///
    ///  - parameter rate:  The rate of rainfall in mm/hr.
    ///  - parameter units: The general units being used (e.g. "us", "si", etc.).
    ///
    ///  - returns: The term for the given rain intensity.
    ///
    static func intensity(_ rate: Double, units: String) -> String {
        switch units {
        case "us", "ca":
            return intensityUS(rate)
        case "uk", "si":
            return intensityUK(rate)
        default:
            return intensityUK(rate)
        }
    }

    fileprivate static func intensityUS(_ rate: Double) -> String {
        switch true {
        case rate == 0:
            return dryUS.name
        case rate < lightRainUS.rate:
            return lightRainUS.name
        case rate < moderateRainUS.rate:
            return moderateRainUS.name
        case rate < heavyRainUS.rate:
            return heavyRainUS.name
        default:
            return violentRainUS.name
        }
    }

    fileprivate static func intensityUK(_ rate: Double) -> String {
        switch true {
        case rate == 0.0:
            return dryUK.name
        case rate < slightRainUK.rate:
            return slightRainUK.name
        case rate < moderateRainUK.rate:
            return moderateRainUK.name
        case rate < heavyRainUK.rate:
            return heavyRainUK.name
        default:
            return violentRainUK.name
        }
    }
}
