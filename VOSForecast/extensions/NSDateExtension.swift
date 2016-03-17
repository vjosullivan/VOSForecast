//
//  NSDateExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 17/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension NSDate {

    func asYYYYMMDD() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(self)
    }
}