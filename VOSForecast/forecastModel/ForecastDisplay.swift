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
        return wholeDegree(currentWeather?.temperature)
    }

    var currentFeelsLikeDisplay: String {
        return wholeDegree(currentWeather?.apparentTemperature)
    }

    var currentDewPointDisplay: String {
        return wholeDegree(currentWeather?.dewPoint)
    }

    var highTodayDisplay: String {
        return wholeDegree(oneDayForecast?.temperatureMax)
    }

    var lowTodayDisplay: String {
        return wholeDegree(oneDayForecast?.temperatureMin)
    }

    var cloudCoverDisplay: String {
        if let cover = currentWeather?.cloudCover {
            return wholeDegree(cover * 100.0) + "%"
        } else {
            return "unknown"
        }
    }

    private func wholeDegree(temperature: Double?) -> String {
        return String(lround(temperature ?? 0.0))
    }
}
