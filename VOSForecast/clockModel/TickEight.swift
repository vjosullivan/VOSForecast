//
//  TickEight.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the hour tick marks on a clock face.
///
class TickEight: TickMark {

    init() {
        super.init(
            color: UIColor.whiteColor(),
            alpha: 1.0,
            innerRadius: 0.925,
            outerRadius: 0.97,
            width: 1.75)
    }
}
