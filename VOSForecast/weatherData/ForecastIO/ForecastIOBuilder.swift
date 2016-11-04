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
        let sevenDayForecast = parseSevenDayForecast(json, units: units)
        var todaysForecast: DataPoint? = nil
        var earliestDate = Date.distantFuture
        for day in (sevenDayForecast?.oneDayForecasts)! {
            if day.time < earliestDate {
                earliestDate = day.time! as Date
                todaysForecast = day
            }
        }
        let oneHourForecasts = parseOneHourForecasts(json, units: units)
        let sixtyMinuteForecast = parseSixtyMinuteForecast(json)
        let flags    = parseFlags(json)
        let timezone = json["timezone"] as? String
        let offset   = json["offset"] as? Double
        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            weather: weather,
            oneDayForecast: todaysForecast,
            sevenDayForecast: sevenDayForecast,
            oneHourForecasts: oneHourForecasts,
            sixtyMinuteForecast: sixtyMinuteForecast,
            flags: flags,
            timezone:  timezone,
            offset: offset,
            units: Units(units: flags?.units ?? ""))
        return forecast
    }
    
    fileprivate func parseWeather(_ json: [String: AnyObject], units: DarkSkyUnits) -> Weather? {
        var weather: Weather?
        if let currently = json["currently"] as? [String: AnyObject] {
            //print(currently)
            let time = currently["time"] as? Int
            let icon = currently["icon"] as? String
            let summary = currently["summary"] as? String

            let temperature = Measurement(optionalValue: currently["temperature"], unit: units.temperature)
            let apparentTemperature = Measurement(optionalValue: currently["apparentTemperature"], unit: units.temperature)
            let dewPoint = Measurement(optionalValue: currently["dewPoint"], unit: units.temperature)

            let precipIntensity = currently["precipIntensity"] as? Double
            let precipProbability = currently["precipProbability"] as? Double
            let windSpeed = currently["windSpeed"] as? Double
            let nearestStormBearing = currently["nearestStormBearing"] as? Double
            let nearestStormDistance = currently["nearestStormDistance"] as? Double
            let cloudCover = currently["cloudCover"] as? Double
            let humidity = currently["humidity"] as? Double
            let windBearing = currently["windBearing"] as? Double
            let visibility = currently["visibility"] as? Double
            let pressure = currently["pressure"] as? Double
            let ozone = currently["ozone"] as? Double
            weather = Weather(time: time,
                icon: icon,
                summary: summary,
                temperature: temperature,
                apparentTemperature: apparentTemperature,
                dewPoint: dewPoint,
                precipIntensity: precipIntensity,
                precipProbability: precipProbability,
                windSpeed: windSpeed,
                nearestStormBearing: nearestStormBearing,
                nearestStormDistance: nearestStormDistance,
                cloudCover: cloudCover,
                humidity: humidity,
                windBearing: windBearing,
                visibility: visibility,
                pressure: pressure,
                ozone: ozone)
        }
        return weather ?? nil
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
    
    fileprivate func parseSevenDayForecast(_ json: [String: AnyObject], units: DarkSkyUnits) -> SevenDayForecast? {
        guard let dailyData = json["daily"] as? [String: AnyObject] else {
            return nil
        }
        let oneDayForecasts = parseOneDayForecasts(dailyData, units: units)
        let icon     = dailyData["icon"] as? String
        let summary  = dailyData["summary"] as? String
        return SevenDayForecast(icon: icon, summary: summary, oneDayForecasts: oneDayForecasts)
    }
    
    fileprivate func parseOneDayForecasts(_ data: [String: AnyObject], units: DarkSkyUnits) -> [DataPoint]? {
        var oneDayForecasts = [DataPoint]()
        if let allDays = data["data"] as? [[String: AnyObject]] {
            for day in allDays {
                //print("Day JSON: \(day)")
                let apparentTemperature = Measurement(optionalValue: day["apparentTemperature"], unit: units.temperature)
                let apparentTemperatureMax = Measurement(optionalValue: day["apparentTemperatureMax"], unit: units.temperature)
                let apparentTemperatureMaxTime: Date?
                if let time = day["apparentTemperatureMaxTime"] as? Double {
                    apparentTemperatureMaxTime = Date(timeIntervalSince1970: time)
                } else {
                    apparentTemperatureMaxTime = nil
                }
                let apparentTemperatureMin = Measurement(optionalValue: day["apparentTemperatureMin"], unit: units.temperature)
                let apparentTemperatureMinTime = Date(timeIntervalSince1970: day["apparentTemperatureMinTime"] as! Double)
                
                let cloudCover = day["cloudCover"] as? Double
                let dewPoint = Measurement(optionalValue: day["dewPoint"], unit: units.temperature)
                let humidity = day["humidity"] as? Double
                let icon = day["icon"] as? String
                let moonPhase = day["moonPhase"] as? Double
                let ozone = day["ozone"] as? Double
                
                let precipIntensity = day["precipIntensity"] as? Double
                let precipIntensityMax = day["precipIntensityMax"] as? Double
                let precipIntensityMaxTime = Date(timeIntervalSince1970: day["precipIntensityMaxTime"] as? Double ?? 0.0)
                let precipProbability = day["precipProbability"] as? Double
                let precipType = day["precipType"] as? String
                
                let pressure = day["pressure"] as? Double
                print("Pressure: \(pressure) \(day["pressure"])")
                let summary = day["summary"] as? String
                let sunriseTime = Date(timeIntervalSince1970: day["sunriseTime"] as! Double)
                let sunsetTime = Date(timeIntervalSince1970: day["sunsetTime"] as! Double)
                
                let temperatureMax = Measurement(optionalValue: day["temperatureMax"], unit: units.temperature)
                let temperatureMaxTime = Date(timeIntervalSince1970: day["temperatureMaxTime"] as! Double)
                let temperatureMin = Measurement(optionalValue: day["temperatureMin"], unit: units.temperature)
                let temperatureMinTime = Date(timeIntervalSince1970: day["temperatureMinTime"] as! Double)
                
                let time = Date(timeIntervalSince1970: day["time"] as! Double)
                let visibility = day["visibility"] as? Double
                
                let windBearing = day["windBearing"] as? Double
                let windSpeed = day["windSpeed"] as? Double
                let oneDayForecast = DataPoint(time: time,
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
                    precipIntensityMax: precipIntensityMax,
                    precipIntensityMaxTime: precipIntensityMaxTime,
                    precipProbability:  precipProbability,
                    precipType: precipType,
                    pressure:  pressure,
                    summary:  summary,
                    sunriseTime: sunriseTime,
                    sunsetTime: sunsetTime,
                    temperature: nil,
                    temperatureMax: temperatureMax,
                    temperatureMaxTime: temperatureMaxTime,
                    temperatureMin: temperatureMin,
                    temperatureMinTime:  temperatureMinTime,
                    visibility: visibility,
                    windBearing:  windBearing,
                    windSpeed: windSpeed)
                oneDayForecasts.append(oneDayForecast)
                print("ODF \(oneDayForecast)")
            }
        }
        return oneDayForecasts.count > 0 ? oneDayForecasts : nil
    }
    
    fileprivate func parseSixtyMinuteForecast(_ json: [String: AnyObject]) -> SixtyMinuteForecast? {
        var sixtyMinuteForecast: SixtyMinuteForecast?
        if let minutely = json["minutely"] as? [String: AnyObject] {
            let oneMinuteForecasts = parseOneMinuteForecasts(minutely)
            let icon     = minutely["icon"] as? String
            let summary  = minutely["summary"] as? String
            sixtyMinuteForecast = SixtyMinuteForecast(icon: icon, summary: summary, sixtyMinuteForecasts: oneMinuteForecasts)
        }
        return sixtyMinuteForecast ?? nil
    }

    fileprivate func parseOneMinuteForecasts(_ json: [String: AnyObject]) -> [DataPoint]? {
        var oneMinuteForecasts = [DataPoint]()
        if let minutes = json["data"] as? [[String: AnyObject]] {
            for minute in minutes {
                let time                 = Date(timeIntervalSince1970: minute["time"] as! Double)
                let precipType           = minute["precipType"] as? String
                let precipIntensity      = minute["precipIntensity"] as? Double
                let precipProbability    = minute["precipProbability"] as? Double
                //let precipIntensityError = minute["precipIntensityError"] as? Double
                oneMinuteForecasts.append(DataPoint(
                    time: time,
                    apparentTemperature: nil,
                    apparentTemperatureMax: nil,
                    apparentTemperatureMaxTime: nil,
                    apparentTemperatureMin: nil,
                    apparentTemperatureMinTime: nil,
                    cloudCover: nil,
                    dewPoint: nil,
                    humidity: nil,
                    icon: nil,
                    moonPhase: nil,
                    ozone: nil,
                    precipIntensity: precipIntensity,
                    precipIntensityMax: nil,
                    precipIntensityMaxTime: nil,
                    precipProbability: precipProbability,
                    precipType: precipType,
                    pressure: nil,
                    summary: nil,
                    sunriseTime: nil,
                    sunsetTime: nil,
                    temperature: nil,
                    temperatureMax: nil,
                    temperatureMaxTime: nil,
                    temperatureMin: nil,
                    temperatureMinTime: nil,
                    visibility: nil,
                    windBearing: nil,
                    windSpeed: nil))
            }
        }
        return oneMinuteForecasts.count > 0 ? oneMinuteForecasts : nil
    }

    fileprivate func parseOneHourForecasts(_ json: [String: AnyObject], units: DarkSkyUnits) -> [DataPoint]? {
        var oneHourForecasts = [DataPoint]()
        if let hourly = json["hourly"] as? [String: AnyObject],
            let hourlyData = hourly["data"] as? [[String: AnyObject]] {
                for hour in hourlyData {
                    // TODO: Absorb temporary variables.
                    let apparentTemperature = Measurement(optionalValue: hour["apparentTemperature"], unit: units.temperature)
                    let cloudCover = hour["cloudCover"] as? Double
                    let dewPoint = Measurement(optionalValue: hour["dewPoint"], unit: units.temperature)
                    let humidity = hour["humidity"] as? Double
                    let icon = hour["icon"] as? String
                    let ozone = hour["ozone"] as? Double
                    let precipIntensity = hour["precipIntensity"] as? Double
                    let precipProbability = hour["precipProbability"] as? Double
                    let precipType = hour["precipType"] as? String
                    let pressure = hour["pressure"] as? Double
                    let summary = hour["summary"] as? String
                    let temperature = Measurement(optionalValue: hour["temperature"], unit: units.temperature)
                    let time = Date(timeIntervalSince1970: hour["time"] as! Double)
                    let visibility = hour["visibility"] as? Double
                    let windBearing = hour["windBearing"] as? Double
                    let windSpeed = hour["windSpeed"] as? Double
                    oneHourForecasts.append(DataPoint(
                        time: time,
                        apparentTemperature: apparentTemperature,
                        apparentTemperatureMax: nil,
                        apparentTemperatureMaxTime: nil,
                        apparentTemperatureMin: nil,
                        apparentTemperatureMinTime: nil,
                        cloudCover: cloudCover,
                        dewPoint: dewPoint,
                        humidity: humidity,
                        icon: icon,
                        moonPhase: nil,
                        ozone: ozone,
                        precipIntensity: precipIntensity,
                        precipIntensityMax: nil,
                        precipIntensityMaxTime: nil,
                        precipProbability: precipProbability,
                        precipType: precipType,
                        pressure: pressure,
                        summary: summary,
                        sunriseTime: nil,
                        sunsetTime: nil,
                        temperature: temperature,
                        temperatureMax: nil,
                        temperatureMaxTime: nil,
                        temperatureMin: nil,
                        temperatureMinTime: nil,
                        visibility: visibility,
                        windBearing: windBearing,
                        windSpeed: windSpeed))
                }
        }
        return oneHourForecasts.count > 0 ? oneHourForecasts : nil
    }
}

