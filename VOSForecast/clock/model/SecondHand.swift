//
//  SecondHand.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 23/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class SecondHand: Hand {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        color           = UIColor(red: 144.0/255.0, green: 212.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        borderColor     = UIColor(red: 144.0/255.0, green: 212.0/255.0, blue: 132.0/255.0, alpha: 0.25)
        backgroundColor = UIColor.clearColor()
        alpha         = 1.0
        width         = 1.5
        length        = 0.95
        offsetLength  = 0.25
        shadowEnabled = false
        tag           = 103
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
