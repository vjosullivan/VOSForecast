//
//  CurrentWeatherView.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 05/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class CurrentWeatherView: UIView {

    @IBOutlet weak var currentTemperature: UILabel!

    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()

        print("Drawn current weather rect.")
    }
}
