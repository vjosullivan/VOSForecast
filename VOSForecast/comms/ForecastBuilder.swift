//
//  WeatherBuilder.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ForecastBuilder {
    
    internal func buildForecast(data: NSData) -> Forecast? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String: AnyObject]
            return parseJSONForecast(json)
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parseJSONForecast(json: [String: AnyObject]) -> Forecast {
        print("\n\nJSON:\n\(json)\n\n")
        var hourlyForecasts = [HourlyForecast]()
        if let hourly = json["hourly"] as? [String: AnyObject],
            let hourlyData = hourly["data"] as? [[String: AnyObject]] {
                for hour in hourlyData {
                    // TODO: Absorb temporary variables.
                    let apparentTemperature = hour["apparentTemperature"] as? Double
                    let cloudCover = hour["cloudCover"] as? Double
                    let dewPoint = hour["dewPoint"] as? Double
                    let humidity = hour["humidity"] as? Double
                    let icon = hour["icon"] as? String
                    let ozone = hour["ozone"] as? Double
                    let precipIntensity = hour["precipIntensity"] as? Double
                    let precipProbability = hour["precipProbability"] as? Double
                    let precipType = hour["precipType"] as? String
                    let pressure = hour["pressure"] as? Double
                    let summary = hour["summary"] as? String
                    let temperature = hour["temperature"] as? Double
                    let time = hour["time"] as? Int
                    let visibility = hour["visibility"] as? Int
                    let windBearing = hour["windBearing"] as? Int
                    let windSpeed = hour["windSpeed"] as? Double
                    hourlyForecasts.append(HourlyForecast(
                        apparentTemperature: apparentTemperature,
                        cloudCover: cloudCover,
                        dewPoint: dewPoint,
                        humidity: humidity,
                        icon: icon,
                        ozone: ozone,
                        precipIntensity: precipIntensity,
                        precipProbability: precipProbability,
                        precipType: precipType,
                        pressure: pressure,
                        summary: summary,
                        temperature: temperature,
                        time: time,
                        visibility: visibility,
                        windBearing: windBearing,
                        windSpeed: windSpeed))
                }
                print("X")
        }
        return Forecast(hourlyForecasts: hourlyForecasts)
    }
}
