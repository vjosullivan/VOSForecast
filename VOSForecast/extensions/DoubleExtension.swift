//
//  DoubleExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 06/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension Double {

    /// Returns a copy of this number, rounded to the given
    /// number of decimal places.
    /// - Note: 1234.5678.round(to: 2) -> 1234.57
    ///
    /// - Parameter decimalPlaces: The required number of decimplaces to round to.
    /// - Returns: A copy of this number, rounded to the given number of decimal places.
    ///
    func round(to decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return (self * divisor).rounded() / divisor
    }
}
