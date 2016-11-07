//
//  DataGroup.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

/// A component of a Dark Sky forecast containing `DataPoint`s for a time period
/// (e.g. every minute for an hour).
struct DataGroup {
    let icon: String?
    let summary: String?
    let dataPoints: [DataPoint]?
    
    ///
    init?(identifier: DataGroupIdentifier, dictionary: [String: AnyObject], units: DarkSkyUnits) {
        guard let data = dictionary[identifier.rawValue] as? [String: AnyObject] else {
            return nil
        }
        icon       = data["icon"] as? String
        summary    = data["summary"] as? String
        dataPoints = DataGroup.dataPoints(from: data, using: units)
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - dictionary: <#dictionary description#>
    ///   - units: <#units description#>
    /// - Returns: <#return value description#>
    fileprivate static func dataPoints(from dictionary: [String: AnyObject], using units: DarkSkyUnits) -> [DataPoint]? {
        var dataGroup = [DataPoint]()
        if let points = dictionary["data"] as? [[String: AnyObject]] {
            for point in points {
                if let dataPoint = DataPoint(dictionary: point, units: units) {
                    dataGroup.append(dataPoint)
                }
            }
        }
        return dataGroup.count > 0 ? dataGroup : nil
    }
}

enum DataGroupIdentifier: String {
    case daily
    case hourly
    case minutely
}
