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
            let newForecast = parseJSONForecast(json)
            print(newForecast.latitude!, newForecast.longitude!)
            return newForecast
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parseJSONForecast(json: [String: AnyObject]) -> Forecast {
        print("\n\nJSON:\n\(json)\n\n")
        let latitude          = json["latitude"] as? Double
        let longitude         = json["longitude"] as? Double
        let currentWeather    = parseCurrentWeather(json)
        let weeklyForecasts   = parseWeeklyForecast(json)
        let hourlyForecasts   = parseHourlyForecasts(json)
        let minutelyForecasts = parseMinutelyForecasts(json)
        let flags    = parseFlags(json)
        let timezone = json["timezone"] as? String
        let offset   = json["offset"] as? Double
        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            currentWeather: currentWeather,
            weeklyForecast: weeklyForecasts,
            hourlyForecasts: hourlyForecasts,
            minutelyForecasts: minutelyForecasts,
            flags: flags,
            timezone:  timezone,
            offset: offset)
        return forecast
    }
    
    private func parseCurrentWeather(json: [String: AnyObject]) -> CurrentWeather? {
        var currentWeather: CurrentWeather?
        if let currently = json["currently"] as? [String: AnyObject] {
            let precipIntensity = currently["precipIntensity"] as? Double
            let icon = currently["icon"] as? String
            let time = currently["time"] as? Int
            let precipProbability = currently["precipProbability"] as? Double
            let windSpeed = currently["windSpeed"] as? Double
            let nearestStormBearing = currently["nearestStormBearing"] as? Double
            let summary = currently["summary"] as? String
            let apparentTemperature = currently["apparentTemperature"] as? Double
            let dewPoint = currently["dewPoint"] as? Double
            let nearestStormDistance = currently["nearestStormDistance"] as? Double
            let cloudCover = currently["cloudCover"] as? Double
            let humidity = currently["humidity"] as? Double
            let windBearing = currently["windBearing"] as? Double
            let temperature = currently["temperature"] as? Double
            let visibility = currently["visibility"] as? Double
            let pressure = currently["pressure"] as? Double
            let ozone = currently["ozone"] as? Double
            currentWeather = CurrentWeather(precipIntensity: precipIntensity,
                icon: icon,
                time: time,
                precipProbability: precipProbability,
                windSpeed: windSpeed,
                nearestStormBearing: nearestStormBearing,
                summary: summary,
                apparentTemperature: apparentTemperature,
                dewPoint: dewPoint,
                nearestStormDistance: nearestStormDistance,
                cloudCover: cloudCover,
                humidity: humidity,
                windBearing: windBearing,
                temperature: temperature,
                visibility: visibility,
                pressure: pressure,
                ozone: ozone)
        }
        return currentWeather ?? nil
    }
    
    private func parseFlags(json: [String: AnyObject]) -> Flags? {
        var flags: Flags?
        return flags ?? nil
    }
    
    private func parseWeeklyForecast(json: [String: AnyObject]) -> WeeklyForecast? {
        var weeklyForecast: WeeklyForecast?
        if let dailyData = json["daily"] as? [String: AnyObject] {
            let weekData = parseDailyForecasts(dailyData)
            let icon     = dailyData["icon"] as? String
            let summary  = dailyData["summary"] as? String
            weeklyForecast = WeeklyForecast(icon: icon, summary: summary, dailyForecasts: weekData)
        }
        return weeklyForecast ?? nil
    }
    
    private func parseDailyForecasts(data: [String: AnyObject]) -> [DailyForecast]? {
        var dailyForecast = [DailyForecast]()
        if let allDays = data["data"] as? [[String: AnyObject]] {
            for day in allDays {
                let apparentTemperatureMax = day["apparentTemperatureMax"] as? Double
                let apparentTemperatureMaxTime = day["apparentTemperatureMaxTime"] as? Double
                let apparentTemperatureMin = day["apparentTemperatureMin"] as? Double
                let apparentTemperatureMinTime = day["apparentTemperatureMinTime"] as? Double
                
                let cloudCover = day["cloudCover"] as? Double
                let dewPoint = day["dewPoint"] as? Double
                let humidity = day["humidity"] as? Double
                let icon = day["icon"] as? Double
                let moonPhase = day["moonPhase"] as? Double
                let ozone = day["ozone"] as? Double
                
                let precipIntensity = day["precipIntensity"] as? Double
                let precipIntensityMax = day["precipIntensityMax"] as? Double
                let precipIntensityMaxTime = day["precipIntensityMaxTime"] as? Double
                let precipProbability = day["precipProbability"] as? Double
                let precipType = day["precipType"] as? String
                
                let pressure = day["pressure"] as? Double
                let summary = day["summary"] as? String
                let sunriseTime = day["sunriseTime"] as? Double
                let sunsetTime = day["sunsetTime"] as? Double
                
                let temperatureMax = day["temperatureMax"] as? Double
                let temperatureMaxTime = day["temperatureMaxTime"] as? Double
                let temperatureMin = day["temperatureMin"] as? Double
                let temperatureMinTime = day["temperatureMinTime"] as? Double
                
                let time = day["time"] as? Double
                let visibility = day["visibility"] as? Double
                
                let windBearing = day["windBearing"] as? Double
                let windSpeed = day["windSpeed"] as? Double
                let dayForecast = DailyForecast(apparentTemperatureMax: apparentTemperatureMax,
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
                    temperatureMax: temperatureMax,
                    temperatureMaxTime: temperatureMaxTime,
                    temperatureMin: temperatureMin,
                    temperatureMinTime:  temperatureMinTime,
                    time: time,
                    visibility: visibility,
                    windBearing:  windBearing,
                    windSpeed: windSpeed)
                dailyForecast.append(dayForecast)
            }
        }
        return dailyForecast.count > 0 ? dailyForecast : nil
    }
    
    private func parseMinutelyForecasts(json: [String: AnyObject]) -> [MinutelyForecast]? {
        let minutelyForecasts = [MinutelyForecast]()
        return minutelyForecasts.count > 0 ? minutelyForecasts : nil
    }
    
    private func parseHourlyForecasts(json: [String: AnyObject]) -> [HourlyForecast]? {
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
        }
        return hourlyForecasts.count > 0 ? hourlyForecasts : nil
    }
}
