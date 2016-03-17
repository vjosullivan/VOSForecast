//
//  DailyData.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

struct OneDayForecast {

    let apparentTemperatureMax: Double?
    let apparentTemperatureMaxTime: NSDate?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMinTime: NSDate?
    
    let cloudCover: Double?
    let dewPoint: Double?
    let humidity: Double?
    let icon: Double?
    let moonPhase: Double?
    let ozone: Double?
    
    let precipIntensity: Double?
    let precipIntensityMax: Double?
    let precipIntensityMaxTime: NSDate?
    let precipProbability: Double?
    let precipType: String?
    
    let pressure: Double?
    let summary: String?
    let sunriseTime: NSDate?
    let sunsetTime: NSDate?
    
    let temperatureMax: Double?
    let temperatureMaxTime: NSDate?
    let temperatureMin: Double?
    let temperatureMinTime: NSDate?
    
    let time: NSDate?
    let visibility: Double?
    
    let windBearing: Double?
    let windSpeed: Double?
}

extension OneDayForecast: CustomStringConvertible {

    var description: String {
        let precipPercent: String
        if let prob = precipProbability {
            precipPercent = String(prob * 100.0)
        } else {
            precipPercent = "?"
        }
        return "Day: \(time?.asYYYYMMDD() ?? "?")\nPrecipitation: \(precipType ?? "?") \(String(precipPercent) ?? "?")%"
    }
}
