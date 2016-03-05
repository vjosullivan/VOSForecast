//
//  TickFive.swift
//  VOSClock
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the hour tick marks on a clock face.
///
class TickFive: TickMark {
    
    init() {
        super.init(
            color: UIColor.whiteColor(),
            alpha: 1.0,
            innerRadius: 0.89,
            outerRadius: 0.95,
            width: 2.0)
    }
}
