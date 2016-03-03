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
        return halfDegree(currentWeather?.temperature) + temperatureUnitsDisplay
    }

    var currentFeelsLikeDisplay: String {
        return halfDegree(currentWeather?.apparentTemperature) + temperatureUnitsDisplay
    }

    var currentDewPointDisplay: String {
        return halfDegree(currentWeather?.dewPoint) + temperatureUnitsDisplay
    }

    private func wholeDegree(temperature: Double?) -> String {
        return String(lround(temperature ?? 0.0))
    }
    private func halfDegree(temperature: Double?) -> String {
        var t = String(Double(lround((temperature ?? 0.0) * 2)) / 2.0)
        if t.characters.last! == "0" {
            t = String(t.characters.dropLast(2))
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
