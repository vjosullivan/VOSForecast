//
//  TickOne.swift
//  VOSClock
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the minute/second tick marks on a clock face.
///
class TickOne: TickMark {
    
    init() {
        super.init(
            color: UIColor.whiteColor(),
            alpha: 1.0,
            innerRadius: 0.90,
            outerRadius: 0.95,
            width: 1.0)
    }
}
