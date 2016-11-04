//
//  WeatherBuilder.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

class ForecastIOBuilder {
    
    internal func buildForecast(_ data: Data) -> Forecast? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
            let newForecast = parseJSONForecast(json)
            print("\n\n\nNEW FORECAST\n\n\n")
            dump(newForecast)
            return newForecast
        } catch {
            print(error)
        }
        return nil
    }
    
    fileprivate func parseJSONForecast(_ json: [String: AnyObject]) -> Forecast {
        let latitude         = json["latitude"] as? Double
        let longitude        = json["longitude"] as? Double
        let units            = DarkSkyUnits(code: json["flags"]?["units"] as? String ?? "us")
        let weather          = parseWeather(json, units: units)
        let sevenDayForecast    = parseSevenDayForecast(json, units: units)
        let oneHourForecasts    = parseOneHourForecasts(json, units: units)
        let sixtyMinuteForecast = parseSixtyMinuteForecast(json, units: units)
        let flags    = parseFlags(json)
        let timezone = json["timezone"] as? String
        let offset   = json["offset"] as? Double
        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            currentWeather: weather,
            daily: sevenDayForecast,
            hourly: oneHourForecasts,
            minutely: sixtyMinuteForecast,
            flags: flags,
            timezone:  timezone,
            offset: offset,
            units: DarkSkyUnits(code: flags?.units ?? ""))
        return forecast
    }
    
    fileprivate func parseWeather(_ json: [String: AnyObject], units: DarkSkyUnits) -> DataPoint? {
        guard let currently = json["currently"] as? [String: AnyObject] else {
            return nil
        }
        return parseDataPoint(currently, units: units)
    }
    
    fileprivate func parseFlags(_ json: [String: AnyObject]) -> Flags? {
        var allFlags: Flags?
        if let flags = json["flags"] as? [String: AnyObject] {
            let isdStations = flags["isd-stations"] as? [String]
            let sources = flags["sources"] as? [String]
            let madisStations = flags["madis-stations"] as? [String]
            let units = flags["units"] as? String
            let darkskyStations = flags["darksky-stations"] as? [String]
            let datapointStations = flags["datapoint-stations"] as? [String]
            allFlags = Flags(units: units,
                sources: sources,
                isdStations: isdStations,
                madisStations: madisStations,
                darkskyStations: darkskyStations,
                datapointStations: datapointStations)
        }
        return allFlags ?? nil
    }
    
    fileprivate func parseSevenDayForecast(_ json: [String: AnyObject], units: DarkSkyUnits) -> DataGroup? {
        guard let dailyData = json["daily"] as? [String: AnyObject] else {
            return nil
        }
        let oneDayForecasts = parseDataGroup(dailyData, units: units)
        let icon     = dailyData["icon"] as? String
        let summary  = dailyData["summary"] as? String
        return DataGroup(icon: icon, summary: summary, dataPoints: oneDayForecasts)
    }
    
    fileprivate func parseDataGroup(_ data: [String: AnyObject], units: DarkSkyUnits) -> [DataPoint]? {
        var dataGroup = [DataPoint]()
        if let points = data["data"] as? [[String: AnyObject]] {
            for point in points {
                if let dataPoint = parseDataPoint(point, units: units) {
                    dataGroup.append(dataPoint)
                }
                print("ODF \(dataGroup)")
            }
        }
        return dataGroup.count > 0 ? dataGroup : nil
    }
    
    fileprivate func parseDataPoint(_ point: [String: AnyObject], units: DarkSkyUnits) -> DataPoint? {
        let temperature = Measurement(optionalValue: point["temperature"], unit: units.temperature)
        let apparentTemperature = Measurement(optionalValue: point["apparentTemperature"], unit: units.temperature)
        let apparentTemperatureMax = Measurement(optionalValue: point["apparentTemperatureMax"], unit: units.temperature)
        let apparentTemperatureMaxTime = Date(unixDate: point["apparentTemperatureMaxTime"])
        let apparentTemperatureMin = Measurement(optionalValue: point["apparentTemperatureMin"], unit: units.temperature)
        let apparentTemperatureMinTime = Date(unixDate: point["apparentTemperatureMinTime"])
        
        let cloudCover = point["cloudCover"] as? Double
        let dewPoint = Measurement(optionalValue: point["dewPoint"], unit: units.temperature)
        let humidity = point["humidity"] as? Double
        let icon = point["icon"] as? String
        let moonPhase = point["moonPhase"] as? Double
        let ozone = point["ozone"] as? Double
        
        let precipIntensity = point["precipIntensity"] as? Double
        let precipIntensityError = point["precipIntensityError"] as? Double
        let precipIntensityMax = point["precipIntensityMax"] as? Double
        let precipIntensityMaxTime = Date(timeIntervalSince1970: point["precipIntensityMaxTime"] as? Double ?? 0.0)
        let precipProbability = point["precipProbability"] as? Double
        let precipType = point["precipType"] as? String
        
        let pressure = point["pressure"] as? Double
        print("Pressure: \(pressure) \(point["pressure"])")
        let summary = point["summary"] as? String
        let sunriseTime = Date(unixDate: point["sunriseTime"])
        let sunsetTime = Date(unixDate: point["sunsetTime"])
        
        let temperatureMax = Measurement(optionalValue: point["temperatureMax"], unit: units.temperature)
        let temperatureMaxTime = Date(unixDate: point["temperatureMaxTime"])
        let temperatureMin = Measurement(optionalValue: point["temperatureMin"], unit: units.temperature)
        let temperatureMinTime = Date(unixDate: point["temperatureMinTime"])
        
        let time = Date(timeIntervalSince1970: point["time"] as! Double)
        let visibility = point["visibility"] as? Double
        
        let windBearing = point["windBearing"] as? Double
        let windSpeed = point["windSpeed"] as? Double
        return DataPoint(time: time,
                                  apparentTemperature: apparentTemperature,
                                  apparentTemperatureMax: apparentTemperatureMax,
                                  apparentTemperatureMaxTime: apparentTemperatureMaxTime,
                                  apparentTemperatureMin: apparentTemperatureMin,
                                  apparentTemperatureMinTime: apparentTemperatureMinTime,
                                  cloudCover:  cloudCover,
                                  dewPoint: dewPoint,
                                  humidity: humidity,
                                  icon: icon,
                                  moonPhase: moonPhase,
                                  ozone: ozone,
                                  precipIntensity: precipIntensity,
                                  precipIntensityError: precipIntensityError,
                                  precipIntensityMax: precipIntensityMax,
                                  precipIntensityMaxTime: precipIntensityMaxTime,
                                  precipProbability:  precipProbability,
                                  precipType: precipType,
                                  pressure:  pressure,
                                  summary:  summary,
                                  sunriseTime: sunriseTime,
                                  sunsetTime: sunsetTime,
                                  temperature: temperature,
                                  temperatureMax: temperatureMax,
                                  temperatureMaxTime: temperatureMaxTime,
                                  temperatureMin: temperatureMin,
                                  temperatureMinTime:  temperatureMinTime,
                                  visibility: visibility,
                                  windBearing:  windBearing,
                                  windSpeed: windSpeed)
    }
    
    fileprivate func parseSixtyMinuteForecast(_ json: [String: AnyObject], units: DarkSkyUnits) -> DataGroup? {
        var dataGroup: DataGroup?
        if let minutely = json["minutely"] as? [String: AnyObject] {
            let dataPoints = parseDataGroup(minutely, units: units)
            let icon     = minutely["icon"] as? String
            let summary  = minutely["summary"] as? String
            dataGroup = DataGroup(icon: icon, summary: summary, dataPoints: dataPoints)
        }
        return dataGroup ?? nil
    }

    fileprivate func parseOneHourForecasts(_ json: [String: AnyObject], units: DarkSkyUnits) -> DataGroup? {
        guard let hourlyData = json["hourly"] as? [String: AnyObject] else {
            return nil
        }
        let points   = parseDataGroup(hourlyData, units: units)
        let icon     = hourlyData["icon"] as? String
        let summary  = hourlyData["summary"] as? String
        return DataGroup(icon: icon, summary: summary, dataPoints: points)
    }
}

fileprivate extension Date {
    
    /// Returns a `Date` provided it can be generated from the supplied data.
    ///
    /// - parameter value: A Unix date value.
    /// - returns: A `Date` provided it can be generated from the supplied data, otherwise nil.
    ///
    init?(unixDate: AnyObject?) {
        guard let value = unixDate as? TimeInterval else {
            return nil
        }
        self.init(timeIntervalSince1970: value)
    }
}
