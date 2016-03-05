//
//  ForecastDisplay.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 03/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

extension Forecast {

    var currentTemperatureDisplay: String {
        return rounded(currentWeather?.temperature) + temperatureUnitsDisplay
    }

    var currentFeelsLikeDisplay: String {
        return rounded(currentWeather?.apparentTemperature) + temperatureUnitsDisplay
    }

    var currentDewPointDisplay: String {
        return rounded(currentWeather?.dewPoint) + temperatureUnitsDisplay
    }

    private func wholeDegree(temperature: Double?) -> String {
        return String(lround(temperature ?? 0.0))
    }
    private func rounded(temperature: Double?) -> String {
        let t: String
        if NSUserDefaults.read(key: "units", defaultValue: "auto") == "us" {
            // Round to nearest degree.
            t = String(lround(temperature ?? 0.0))
        } else {
            // Round to nearest half degree.
            let temp = String(Double(lround((temperature ?? 0.0) * 2)) / 2.0)
            t = temp.characters.last! == "0" ? String(temp.characters.dropLast(2)) : temp
        }
        return t
    }

    var temperatureUnitsDisplay: String {
        let unit: String
        if flags?.units == "us" {
            unit = "°F"
        } else {
            unit = "°C"
        }
        return unit
    }
}
