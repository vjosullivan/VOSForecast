//
//  SmallTick.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the minute/second tick marks on a clock face.
///
class SmallTick: Tick {
    
    init() {
        super.init(
            color: UIColor.whiteColor(),
            alpha: 1.0,
            innerRadius: 0.95,
            outerRadius: 0.97,
            width: 1.0)
    }
}
