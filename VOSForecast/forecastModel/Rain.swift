//
//  Rain.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct Rain {

    // US AMS definition
    static let lightRainUS     = (rate:    2.5, name: "Light rain")
    static let moderateRainUS  = (rate:    7.6, name: "Moderate rain")
    static let heavyRainUS     = (rate:   50.0, name: "Heavy rain")
    static let violentRainUS   = (rate: 1000.0, name: "Violent rain")

    // UK Met. Office definitions.
    static let slightRainUK   = (rate:    2.0, name: "Slight rain")
    static let moderateRainUK = (rate:   10.0, name: "Moderate rain")
    static let heavyRainUK    = (rate:   50.0, name: "Heavy rain")
    static let violentRainUK  = (rate: 1000.0, name: "Violent rain")

    static func intensity(rate: Double, units: String) -> String {
        switch units {
            case "us", "ca":
            return intensityUS(rate)
            case "uk", "si":
            return intensityUK(rate)
        default:
            return intensityUK(rate)
        }
    }

    private static func intensityUS(rate: Double) -> String {
        switch true {
        case rate == 0:
            return "Dry"
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

    private static func intensityUK(rate: Double) -> String {
        switch true {
        case rate == 0:
            return "Dry"
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
