//
//  DataPoint.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

struct DataPoint {

    /// The UNIX time at which this data point begins.  Required.
    let timestamp: Date?

    /// The apparent or "feels like" temperature.  Not given on daily data point.  Optional.
    let apparentTemperature: Measurement<UnitTemperature>?
    let apparentTemperatureMax: Measurement<UnitTemperature>?
    let apparentTemperatureMaxTime: Date?
    let apparentTemperatureMin: Measurement<UnitTemperature>?
    let apparentTemperatureMinTime: Date?
    
    let cloudCover: Double?
    let dewPoint: Measurement<UnitTemperature>?
    let humidity: Double?
    let icon: String?
    let moonPhase: Double?
    let ozone: Double?
    
    let precipIntensity: Double?
    let precipIntensityError: Double?
    let precipIntensityMax: Double?
    let precipIntensityMaxTime: Date?
    let precipProbability: Double?
    let precipType: String?
    
    let pressure: Double?
    let summary: String?
    let sunriseTime: Date?
    let sunsetTime: Date?
    
    let temperature: Measurement<UnitTemperature>?
    let temperatureMax: Measurement<UnitTemperature>?
    let temperatureMaxTime: Date?
    let temperatureMin: Measurement<UnitTemperature>?
    let temperatureMinTime: Date?
    
    let visibility: Double?
    
    let windBearing: Double?
    let windSpeed: Double?

    init?(dictionary: [String: AnyObject]?, units: DarkSkyUnits) {
        guard let point = dictionary else {
            return nil
        }
        timestamp = Date(timeIntervalSince1970: point["time"] as! Double)

        temperature = Measurement(optionalValue: point["temperature"], unit: units.temperature)
        apparentTemperature = Measurement(optionalValue: point["apparentTemperature"], unit: units.temperature)
        apparentTemperatureMax = Measurement(optionalValue: point["apparentTemperatureMax"], unit: units.temperature)
        apparentTemperatureMaxTime = Date(unixDate: point["apparentTemperatureMaxTime"])
        apparentTemperatureMin = Measurement(optionalValue: point["apparentTemperatureMin"], unit: units.temperature)
        apparentTemperatureMinTime = Date(unixDate: point["apparentTemperatureMinTime"])
        
        cloudCover = point["cloudCover"] as? Double
        dewPoint = Measurement(optionalValue: point["dewPoint"], unit: units.temperature)
        humidity = point["humidity"] as? Double
        icon = point["icon"] as? String
        moonPhase = point["moonPhase"] as? Double
        ozone = point["ozone"] as? Double
        
        precipIntensity = point["precipIntensity"] as? Double
        precipIntensityError = point["precipIntensityError"] as? Double
        precipIntensityMax = point["precipIntensityMax"] as? Double
        precipIntensityMaxTime = Date(timeIntervalSince1970: point["precipIntensityMaxTime"] as? Double ?? 0.0)
        precipProbability = point["precipProbability"] as? Double
        precipType = point["precipType"] as? String
        
        pressure = point["pressure"] as? Double
        summary = point["summary"] as? String
        sunriseTime = Date(unixDate: point["sunriseTime"])
        sunsetTime = Date(unixDate: point["sunsetTime"])
        
        temperatureMax = Measurement(optionalValue: point["temperatureMax"], unit: units.temperature)
        temperatureMaxTime = Date(unixDate: point["temperatureMaxTime"])
        temperatureMin = Measurement(optionalValue: point["temperatureMin"], unit: units.temperature)
        temperatureMinTime = Date(unixDate: point["temperatureMinTime"])
        
        visibility = point["visibility"] as? Double
        
        windBearing = point["windBearing"] as? Double
        windSpeed   = point["windSpeed"] as? Double
    }
}

extension DataPoint: CustomStringConvertible {

    var description: String {
        return "\(summary ?? "No summary") at \(time)."
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
