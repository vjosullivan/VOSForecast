//
//  MinuteHand.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 23/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class MinuteHand: Hand {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        color           = UIColor(white: 0.925, alpha: 1.0)
        borderColor     = UIColor(white: 0.925, alpha: 0.75)
        backgroundColor = UIColor.clearColor()
        alpha         = 1.0
        width         = 3.0
        length        = 0.75
        offsetLength  = 0.1
        shadowEnabled = false
        tag           = 102
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
