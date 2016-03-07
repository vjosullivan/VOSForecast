//
//  SecondHand.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 23/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class SecondHand: ClockHand {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        color           = UIColor(red: 0.75, green: 0.25, blue: 0.25, alpha: 1.0)
        borderColor     = UIColor(red: 0.75, green: 0.25, blue: 0.25, alpha: 0.25)
        backgroundColor = UIColor.clearColor()
        alpha         = 1.0
        width         = 1.5
        length        = 0.9
        offsetLength  = 0.125
        shadowEnabled = false
        tag           = 103
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
