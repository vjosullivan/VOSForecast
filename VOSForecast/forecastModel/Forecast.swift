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

    let currentWeather: DataPoint?

    let daily:    DataGroup?
    let hourly:   DataGroup?
    let minutely: DataGroup?
    
    
    var today: DataPoint? {
        return daily?.dataPoints?[0]
    }

    let flags: Flags?
    let timezone: String?
    let offset: Double?

    let units: DarkSkyUnits
}
