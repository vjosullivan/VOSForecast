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

    private func halfDegree(temperature: Double?) -> String {
        let t = temperature ?? 0.0
        return String(round(t * 2) / 2.0)
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
