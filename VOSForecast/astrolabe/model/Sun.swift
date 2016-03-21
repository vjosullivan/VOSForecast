//
//  Sun.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 21/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct Sun {

    let sunrise: NSDate
    let sunset:  NSDate

    init(sunrise: NSDate, sunset: NSDate) {
        self.sunrise = sunrise
        self.sunset  = sunset
    }
}
