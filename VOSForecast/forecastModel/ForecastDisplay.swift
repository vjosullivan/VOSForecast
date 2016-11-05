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
        guard let temperature = currently?.temperature?.value else {
            return "?"
        }
        return roundToWholeNumber(temperature)
    }

    var currentFeelsLikeDisplay: String {
        guard let temperature = currently?.apparentTemperature?.value else {
            return "?"
        }
        return roundToWholeNumber(temperature)
    }

    var currentDewPointDisplay: String {
        guard let temperature = currently?.dewPoint?.value else {
            return "?"
        }
        return roundToWholeNumber(temperature)
    }

    var highTodayDisplay: String {
        guard let temperature = today?.temperatureMax?.value else {
            return "?"
        }
        return roundToWholeNumber(temperature)
    }

    var lowTodayDisplay: String {
        guard let temperature = today?.temperatureMin?.value else {
            return "?"
        }
        return roundToWholeNumber(temperature)
    }

    var cloudCoverDisplay: String {
        if let cover = currently?.cloudCover {
            return roundToWholeNumber(cover * 100.0) + "%"
        } else {
            return "unknown"
        }
    }

    var highlightColor: UIColor {
        if let t = currently?.temperature?.value {
            return ColorWheel.colorFor(t, unit: flags!.units ?? "si")
        }
        return UIColor.white
    }

    var rainLikelyhoodDisplay: String {
        if let likelyhood = currently?.precipProbability {
            return roundToWholeNumber(likelyhood * 100.0) + "%"
        } else {
            return "unknown"
        }
    }

    fileprivate func roundToWholeNumber(_ temperature: Double?) -> String {
        return String(lround(temperature ?? 0.0))
    }
}
