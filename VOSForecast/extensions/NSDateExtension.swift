//
//  NSDateExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 17/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension Date {

    func asYYYYMMDD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func asHHMM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    func asHpm(showMidday: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let time = formatter.string(from: self).lowercased()
        if showMidday {
            if time == "12pm" {
                return "midday"
            } else if time == "12am" {
                return "midnight"
            }
        }
        return time
    }

    ///  Returns the exact date for the start of today.
    ///
    static func startOfToday() -> Date {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = TimeZone.autoupdatingCurrent
        let components = (cal as NSCalendar).components([.day , .month, .year ], from: Date())
        return cal.date(from: components)!
    }
}
