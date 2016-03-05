//
//  TickFifteen.swift
//  VOSClock
//
//  Created by Vincent O'Sullivan on 25/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// Represents the quarter hour tick marks on a clock face.
///
class TickFifteen: TickMark {
    
    init() {
        super.init(
            color: UIColor.whiteColor(),
            alpha: 1.0,
            innerRadius: 0.87,
            outerRadius: 0.96,
            width: 3.0)
    }
}
