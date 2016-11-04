//
//  MeasurementExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 04/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

extension Measurement {
    
    /// Failable initialiser for handling optional values.
    init?(optionalValue: AnyObject?, unit: UnitType) {
        guard let value = optionalValue as? Double else {
            return nil
        }
        self.value = value
        self.unit  = unit
    }
}
