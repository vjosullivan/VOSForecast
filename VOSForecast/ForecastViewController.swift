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
    
    @IBOutlet weak var clockView: UIView!
    @IBOutlet weak var clockFrontView: UIView!
    @IBOutlet weak var clockRearView: UIView!
    @IBOutlet weak var clockFlipButton: UIButton!
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentFrontView: UIView!
    @IBOutlet weak var currentRearView: UIView!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentFeelsLike: UILabel!
    @IBOutlet weak var currentDewPoint: UILabel!
    @IBOutlet weak var currentSummary: UILabel!
    @IBOutlet weak var currentFrontFlipButton: UIButton!
    @IBOutlet weak var currentRearFlipButton: UIButton!
    
    // MARK: Units
    
    @IBOutlet weak var autoUnits: UIButton!
    @IBOutlet weak var metricUnits: UIButton!
    @IBOutlet weak var ukUnits: UIButton!
    @IBOutlet weak var usUnits: UIButton!
    
    // MARK: - UIViewController functions.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let units = readSetting("units", defaultValue: "auto")
        updateForecast()
    }
    
    func flip(frontView: UIView, rearView: UIView) {
        if rearView.hidden {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromRight, .ShowHideTransitionViews]
            UIView.transitionWithView(frontView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    frontView.hidden = true
                },
                completion: nil)
            
            UIView.transitionWithView(rearView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    rearView.hidden = false
                },
                completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromLeft, .ShowHideTransitionViews]
            UIView.transitionWithView(rearView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    rearView.hidden = true
                },
                completion: nil)
            UIView.transitionWithView(frontView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    frontView.hidden = false
                },
                completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Local functions
    
    private func updateForecast() {
        let units = readSetting("units", defaultValue: "auto")
        ForecastReceiver().fetchWeather(latitude: 51.3, longitude: -1.0, units: units) {(data, error) in
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
        currentSummary.text     = forecast.currentWeather?.summary
    }
    
    private func configureUI() {
        
        currentFrontView.layer.borderWidth = 3
        currentFrontView.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).CGColor
        currentFrontView.layer.cornerRadius = 10
        currentRearView.layer.borderWidth = 3
        currentRearView.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0).CGColor
        currentRearView.layer.cornerRadius = 10
        
        clockFrontView.layer.borderWidth = 3
        clockFrontView.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).CGColor
        clockFrontView.layer.cornerRadius = 10
        clockRearView.layer.borderWidth = 3
        clockRearView.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).CGColor
        clockRearView.layer.cornerRadius = 10
        
        configureUnitButtons()
    }
    
    private func configureUnitButtons() {
        let black = UIColor.blackColor()
        let green = UIColor(red: 144.0/255.0, green: 212.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        autoUnits.setTitleColor(black, forState: .Normal)
        metricUnits.setTitleColor(black, forState: .Normal)
        ukUnits.setTitleColor(black, forState: .Normal)
        usUnits.setTitleColor(black, forState: .Normal)
        let units = readSetting("units", defaultValue: "auto")
        print("Units \(units).")
        switch units {
        case "auto":
            autoUnits.setTitleColor(green, forState: .Normal)
        case "ca":
            metricUnits.setTitleColor(green, forState: .Normal)
        case "uk2":
            ukUnits.setTitleColor(green, forState: .Normal)
        case "us":
            usUnits.setTitleColor(green, forState: .Normal)
        default:
            break
        }
    }
    
    @IBAction func flipPanel(sender: UIButton) {
        switch sender {
        case clockFlipButton:
            flip(clockFrontView, rearView: clockRearView)
        case currentFrontFlipButton, currentRearFlipButton:
            flip(currentFrontView, rearView: currentRearView)
        default:
            break
        }
    }
    
    @IBAction func switchUnits(sender: UIButton) {
        switch sender {
        case autoUnits:
            writeSetting("units", value: "auto")
        case metricUnits:
            writeSetting("units", value: "ca")
        case ukUnits:
            writeSetting("units", value: "uk2")
        case usUnits:
            writeSetting("units", value: "us")
        default:
            break
        }
        configureUnitButtons()
        updateForecast()
    }
}
