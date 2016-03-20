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
        return roundToWholeNumber(currentWeather?.temperature)
    }

    var currentFeelsLikeDisplay: String {
        return roundToWholeNumber(currentWeather?.apparentTemperature)
    }

    var currentDewPointDisplay: String {
        return roundToWholeNumber(currentWeather?.dewPoint)
    }

    var highTodayDisplay: String {
        return roundToWholeNumber(oneDayForecast?.temperatureMax)
    }

    var lowTodayDisplay: String {
        return roundToWholeNumber(oneDayForecast?.temperatureMin)
    }

    var cloudCoverDisplay: String {
        if let cover = currentWeather?.cloudCover {
            return roundToWholeNumber(cover * 100.0) + "%"
        } else {
            return "unknown"
        }
    }

    var rainLikelyhoodDisplay: String {
        if let likelyhood = currentWeather?.precipProbability {
            return roundToWholeNumber(likelyhood * 100.0) + "%"
        } else {
            return "unknown"
        }
    }

    private func roundToWholeNumber(temperature: Double?) -> String {
        return String(lround(temperature ?? 0.0))
    }
}
