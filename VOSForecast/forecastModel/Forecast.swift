//
//  Forecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct Forecast {

    let latitude: Double?
    let longitude: Double?

    let weather: Weather?
    let oneDayForecast: DataPoint?
    let sevenDayForecast: SevenDayForecast?
    let oneHourForecasts: [DataPoint]?
    let sixtyMinuteForecast: SixtyMinuteForecast?

    let flags: Flags?
    let timezone: String?
    let offset: Double?

    let units: Units
}
