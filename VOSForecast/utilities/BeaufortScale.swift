//
//  BeaufortScale.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct BeaufortScale {

    private let speed: Double
    private let units: String

    var description: String {
        return ["Calm", "Light air", "Light breeze", "Gentle breeze",
            "Moderate breeze", "Fresh breeze", "Strong breeze", "Near gale",
            "Gale", "Strong gale", "Storm", "Violent storm", "Hurricane"][number]
    }

    var number: Int {
        switch true {
        case speed < 1.0:
            return 0
        case speed < 4.0:
            return 1
        case speed < 8.0:
            return 2
        case speed < 13.0:
            return 3
        case speed < 19.0:
            return 4
        case speed < 25.0:
            return 5
        case speed < 32.0:
            return 6
        case speed < 39.0:
            return 7
        case speed < 47.0:
            return 8
        case speed < 55.0:
            return 9
        case speed < 64.0:
            return 10
        case speed < 73.0:
            return 11
        default:
            return 12
        }
    }

    init(speed: Double, units: String) {
        switch units {
        case "kph":
            self.speed = speed * 0.621371
        case "m/s":
            self.speed = speed * 2.23694
        default:
            self.speed = speed
        }
        self.units = units
    }
}