//
//  Compass.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct Compass {

    let direction: Double

    var cardinal: String {
        switch true {
        case direction <= 45.0:
            return "N"
        case direction <= 135.0:
            return "E"
        case direction <= 225.0:
            return "S"
        case direction <= 315.0:
            return "W"
        default:
            return "N"
        }
    }

    var ordinal: String {
        switch true {
        case direction <= 90.0:
            return "NE"
        case direction <= 180.0:
            return "SE"
        case direction <= 270.0:
            return "SW"
        default:
            return "NW"
        }
    }

    var principleWind: String {
        switch true {
        case direction <= 22.5:
            return "N"
        case direction <= 67.5:
            return "NE"
        case direction <= 112.5:
            return "E"
        case direction <= 157.5:
            return "SE"
        case direction <= 202.5:
            return "S"
        case direction <= 247.5:
            return "SW"
        case direction <= 292.5:
            return "W"
        case direction <= 337.5:
            return "NW"
        default:
            return "N"
        }
    }

    init(direction: Double) {
        self.direction = abs(direction.truncatingRemainder(dividingBy: 360.0))
    }
}
