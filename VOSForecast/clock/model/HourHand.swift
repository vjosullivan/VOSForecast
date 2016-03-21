//
//  HourHand.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 23/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class HourHand: Hand {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        color           = UIColor(white: 0.7, alpha: 1.0)
        borderColor     = UIColor(white: 0.8, alpha: 0.75)
        backgroundColor = UIColor.clearColor()
        alpha         = 1.0
        width         = 5.0
        length        = 0.5
        offsetLength  = 0.08
        shadowEnabled = false
        tag           = 101
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
