//
//  ForecastViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentFeelsLike: UILabel!
    @IBOutlet weak var currentDewPoint: UILabel!

    // MARK: - UIViewController functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateForecast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Local functions
    
    private func updateForecast() {
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
    
    private func updateView(forecast: Forecast) {

        currentTemperature.text = "\(forecast.currentTemperatureDisplay)"
        currentFeelsLike.text   = "Feels like:  \(forecast.currentFeelsLikeDisplay)"
        currentDewPoint.text    = "Dew point:  \(forecast.currentDewPointDisplay)"
    }

    private func configureUI() {

        currentView.layer.borderWidth = 3
        currentView.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).CGColor
        currentView.layer.cornerRadius = 10
    }
}
