//
//  Forecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

struct Forecast {

    let latitude: Double?
    let longitude: Double?

    let currently: DataPoint?

    let daily:    DataGroup?
    let hourly:   DataGroup?
    let minutely: DataGroup?
    
    let flags: Flags?
    let timezone: String?
    let offset: Double?

    let units: DarkSkyUnits

    /// Forecast for all of today (as opposed to current conditions).
    /// (The first day of the daily forecasts.)
    var today: DataPoint? {
        return daily?.dataPoints?[0]
    }

    init?(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
            self.init(dictionary: json)
        } catch {
            print(error)
        }
        return nil
    }

    init?(dictionary: [String: AnyObject]) {
        
        flags     = Forecast.flags(dictionary)
        units     = DarkSkyUnits(code: flags?.units ?? "us")
        
        latitude  = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        currently = DataPoint(dictionary: dictionary["currently"] as? [String: AnyObject], units: units)
        daily     = DataGroup(identifier: .daily, dictionary: dictionary, units: units)
        hourly    = DataGroup(identifier: .hourly, dictionary: dictionary, units: units)
        minutely  = DataGroup(identifier: .minutely, dictionary: dictionary, units: units)
        timezone  = dictionary["timezone"] as? String
        offset    = dictionary["offset"] as? Double
    }
    
    fileprivate static func flags(_ json: [String: AnyObject]) -> Flags? {
        var allFlags: Flags?
        if let flags = json["flags"] as? [String: AnyObject] {
            let isdStations       = flags["isd-stations"] as? [String]
            let sources           = flags["sources"] as? [String]
            let madisStations     = flags["madis-stations"] as? [String]
            let units             = flags["units"] as? String
            let darkskyStations   = flags["darksky-stations"] as? [String]
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
}
