//
//  TickZero.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the "12 o'clock" tick mark on a clock face.
///
class TickZero: Tick {
    
    convenience init() {
        self.init(color: UIColor(red: 144.0/255.0, green: 212.0/255.0, blue: 132.0/255.0, alpha: 1.0))
    }

    init(color: UIColor) {
        super.init(
            color: color,
            alpha: 1.0,
            innerRadius: 0.90,
            outerRadius: 0.99,
            width: 3.0)
    }
}
