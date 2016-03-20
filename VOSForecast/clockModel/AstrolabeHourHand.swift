//
//  AstrolabeHourHand.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class AstrolabeHourHand: ClockHand {

    override init(frame: CGRect) {
        super.init(frame: frame)

        color           = UIColor.redColor()
        borderColor     = UIColor.redColor()
        backgroundColor = UIColor.clearColor()
        alpha         = 1.0
        width         = 5.0
        length        = 0.9
        offsetLength  = 0.08
        shadowEnabled = false
        tag           = 101
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
