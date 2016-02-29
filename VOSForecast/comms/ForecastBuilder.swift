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
        if let hourly = json["hourly"] as? [String: AnyObject],
            let hourlyData = hourly["data"] as? [[String: AnyObject]] {
                var hourlyForecasts = [HourlyForecast]()
                for hour in hourlyData {
                    apparentTemperature = "30.54";
                    cloudCover = "0.3";
                    dewPoint = "34.37";
                    humidity = "0.8100000000000001";
                    icon = "partly-cloudy-night";
                    ozone = "359.4";
                    precipIntensity = "0.0015";
                    precipProbability = "0.03";
                    precipType = rain;
                    pressure = 1002;
                    summary = "Partly Cloudy";
                    temperature = "39.65";
                    time = 1456952400;
                    visibility = 10;
                    windBearing = 292;
                    windSpeed = "17.93";
                    hourlyForecasts.append(HourlyForecast())
                }
                print("X")
        }
        return Forecast()
    }
}
