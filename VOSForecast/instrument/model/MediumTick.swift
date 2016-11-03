//
//  MediumTick.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the hour tick marks on a clock face.
///
class MediumTick: Tick {
    
    init() {
        super.init(
            color: UIColor.white,
            alpha: 1.0,
            innerRadius: 0.925,
            outerRadius: 0.99,
            width: 2.0)
    }
}
