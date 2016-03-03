//
//  UserDefaults.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 03/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

func writeSetting(key: String, value: String) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(value, forKey: key)
    userDefaults.synchronize()
}

func readSetting(key: String, defaultValue: String) -> String {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.valueForKey(key) as? String ?? defaultValue
}

