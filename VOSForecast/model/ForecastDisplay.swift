//
//  ForecastDisplay.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 03/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Darwin

extension Forecast {

    var currentTemperatureDisplay: String {
        let tempRound = currentWeather?.temperature ?? 0.0

        let temp = String(Int(round(tempRound)))
        let unit: String
        if flags?.units == "us" {
            unit = "°F"
        } else {
            unit = "°C"
        }
        return temp + unit
    }

    var currentFeelsLikeDisplay: String {
        let tempRound = currentWeather?.apparentTemperature ?? 0.0

        let temp = String(Int(round(tempRound)))
        let unit: String
        if flags?.units == "us" {
            unit = "°F"
        } else {
            unit = "°C"
        }
        return temp + unit
    }

    var currentDewPointDisplay: String {
        let tempRound = currentWeather?.dewPoint ?? 0.0

        let temp = String(Int(round(tempRound)))
        let unit: String
        if flags?.units == "us" {
            unit = "°F"
        } else {
            unit = "°C"
        }
        return temp + unit
    }
}
