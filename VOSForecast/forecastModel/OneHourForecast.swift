//
//  OneHourForecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

struct OneHourForecast {
    
    let apparentTemperature: Measurement<UnitTemperature>?
    let cloudCover: Double?
    let dewPoint: Double?
    let humidity: Double?
    let icon: String?
    let ozone: Double?
    let precipIntensity: Double?
    let precipProbability: Double?
    let precipType: String?
    let pressure: Double?
    let summary: String?
    let temperature: Measurement<UnitTemperature>?
    let time: Int?
    let visibility: Int?
    let windBearing: Int?
    let windSpeed: Double?
}
