//
//  Units.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

//struct Units {
//
//    fileprivate let systems      = ["si",  "ca",  "uk2", "us"]
//    fileprivate let temperatures = ["°C",  "°C",  "°C",  "°F"]
//    fileprivate let windSpeeds   = ["m/s", "kph", "mph", "mph"]
//
//    fileprivate let unitSystem: Int
//
//    var temperature: String { return temperatures[unitSystem] }
//    var windSpeed: String   { return windSpeeds[unitSystem]   }
//
//    init(units: String) {
//        if let index = systems.index(of: units) {
//            unitSystem = index
//        } else {
//            unitSystem = 0
//        }
//    }
//}
