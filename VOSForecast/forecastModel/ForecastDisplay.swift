//
//  ForecastDisplay.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 03/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import UIKit

extension Forecast {

    var currentTemperatureDisplay: String {
        return roundToWholeNumber(weather?.temperature)
    }

    var currentFeelsLikeDisplay: String {
        return roundToWholeNumber(weather?.apparentTemperature)
    }

    var currentDewPointDisplay: String {
        return roundToWholeNumber(weather?.dewPoint)
    }

    var highTodayDisplay: String {
        return roundToWholeNumber(oneDayForecast?.temperatureMax)
    }

    var lowTodayDisplay: String {
        return roundToWholeNumber(oneDayForecast?.temperatureMin)
    }

    var cloudCoverDisplay: String {
        if let cover = weather?.cloudCover {
            return roundToWholeNumber(cover * 100.0) + "%"
        } else {
            return "unknown"
        }
    }

    var highlightColor: UIColor {
        if let t = weather!.temperature {
            return ColorWheel.colorFor(t, unit: flags!.units ?? "si")
        }
        return UIColor.whiteColor()
    }

    var rainLikelyhoodDisplay: String {
        if let likelyhood = weather?.precipProbability {
            return roundToWholeNumber(likelyhood * 100.0) + "%"
        } else {
            return "unknown"
        }
    }

    private func roundToWholeNumber(temperature: Double?) -> String {
        return String(lround(temperature ?? 0.0))
    }
}
