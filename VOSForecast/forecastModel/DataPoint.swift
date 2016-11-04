//
//  DailyData.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

struct DataPoint {

    /// The UNIX time at which this data point begins.  Required.
    let time: Date?

    /// The apparent or "feels like" temperature.  Not given on daily data point.  Optional.
    let apparentTemperature: Measurement<UnitTemperature>?
    let apparentTemperatureMax: Measurement<UnitTemperature>?
    let apparentTemperatureMaxTime: Date?
    let apparentTemperatureMin: Measurement<UnitTemperature>?
    let apparentTemperatureMinTime: Date?
    
    let cloudCover: Double?
    let dewPoint: Measurement<UnitTemperature>?
    let humidity: Double?
    let icon: Double?
    let moonPhase: Double?
    let ozone: Double?
    
    let precipIntensity: Double?
    let precipIntensityMax: Double?
    let precipIntensityMaxTime: Date?
    let precipProbability: Double?
    let precipType: String?
    
    let pressure: Double?
    let summary: String?
    let sunriseTime: Date?
    let sunsetTime: Date?
    
    let temperatureMax: Measurement<UnitTemperature>?
    let temperatureMaxTime: Date?
    let temperatureMin: Measurement<UnitTemperature>?
    let temperatureMinTime: Date?
    
    let visibility: Double?
    
    let windBearing: Double?
    let windSpeed: Double?
}
protocol Numeric {}
extension Double: Numeric {}

extension Optional where Wrapped: Numeric {
    
    func toString(defaultValue: String = "?") -> String {
        if let d = self {
            return String(describing: d)
        } else {
            return defaultValue
        }
    }
}

extension DataPoint: CustomStringConvertible {

    var description: String {
        let precipPercent: String
        if let prob = precipProbability {
            precipPercent = String(Int(prob * 100.0))
        } else {
            precipPercent = "?"
        }
        let sun  = "\(time?.asYYYYMMDD() ?? "?") \(time?.asHHMM() ?? "?") rise=\(sunriseTime?.asHHMM() ?? "?") set=\(sunsetTime?.asHHMM() ?? "?")"
        
        let tMin = "Low of:  \(temperatureMin) at \(temperatureMinTime?.asHHMM() ?? "?")"
        let tMax = "High of: \(temperatureMax) at \(temperatureMaxTime?.asHHMM() ?? "?")"
        let rain = "Precip:  \(precipType ?? "?") \(precipPercent)% in=\(precipIntensity.toString()) inmx=\(precipIntensityMax.toString()) at \(precipIntensityMaxTime?.asHHMM() ?? "?")"
        return "Day: \(sun)\n\(tMin)\n\(tMax)\n\(rain)\n"
    }
}
