//
//  TickZero.swift
//  VOSClock
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the "12 o'clock" tick mark on a clock face.
///
class TickZero: TickMark {
    
    init() {
        super.init(
            color: UIColor.yellowColor(),
            alpha: 1.0,
            innerRadius: 0.85,
            outerRadius: 0.96,
            width: 4.0)
    }
}
