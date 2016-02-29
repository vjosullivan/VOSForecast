//
//  ForecastViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
}

// MARK: - UIViewController methods.

extension ForecastViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateForecast()
    }
    
    func updateForecast() {
        ForecastReceiver().fetchWeather(latitude: 51.3, longitude: -1.0) {(data, error) in
            if let data = data {
                dispatch_async(dispatch_get_main_queue()) {
                    if let forecast = ForecastBuilder().buildForecast(data) {
                        self.updateView(forecast)
                    } else {
                        print("CLONK!")
                    }
                }
            }
            if let error = error {
                print("ERROR: \(error.description)")
            }
        }
    }
    
    func updateView(forecast: Forecast) {
        print("Updating forecast...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
