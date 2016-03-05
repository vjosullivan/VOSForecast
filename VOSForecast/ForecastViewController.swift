//
//  ForecastViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    // MARK: - Clock properties
    
    @IBOutlet weak var mainClock: VOSClockView!
    
    var timeText: String = ""
    
    internal var hours:   Int = 0
    internal var minutes: Int = 0
    internal var seconds: Int = 0
    
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

    @IBOutlet weak var weatherIcon: UILabel!

    // MARK: Units

    @IBOutlet weak var autoUnits: UIButton!
    @IBOutlet weak var metricUnits: UIButton!
    @IBOutlet weak var ukUnits: UIButton!
    @IBOutlet weak var usUnits: UIButton!

    // MARK: Summary

    @IBOutlet weak var oneHourView: UIView!
    @IBOutlet weak var oneDayView: UIView!
    @IBOutlet weak var oneWeekView: UIView!
    @IBOutlet weak var oneHourSummary: UILabel!
    @IBOutlet weak var oneDaySummary: UILabel!
    @IBOutlet weak var oneWeekSummary: UILabel!
    @IBOutlet weak var summaryFlipButton: UIButton!
    
    // MARK: - UIViewController functions.

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: WeatherIcons-Regular
        configureUI()
        updateForecast()
    
        // Configure main clock.
        mainClock.delegate = self
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
    
    func flop(frontView: UIView, middleView: UIView, rearView: UIView) {
        if !frontView.hidden {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .ShowHideTransitionViews]
            UIView.transitionWithView(frontView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    frontView.hidden = true
                },
                completion: nil)

            UIView.transitionWithView(middleView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    middleView.hidden = false
                },
                completion: nil)
        } else if !middleView.hidden {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .ShowHideTransitionViews]
            UIView.transitionWithView(middleView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    middleView.hidden = true
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
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .ShowHideTransitionViews]
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
        let units = NSUserDefaults.read(key: "units", defaultValue: "auto")
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

        weatherIcon.text = weatherIcon(forecast.currentWeather?.icon)
        if weatherIcon.text == "\u{F00D}" {
            weatherIcon.textColor = UIColor.yellowColor()
        } else {
            weatherIcon.textColor = UIColor.whiteColor()
        }

        oneHourSummary.text = "1 hour summary: " + (forecast.sixtyMinuteForecast?.summary ?? "Not available")
        oneDaySummary.text  = "24 hour summary:  " + (forecast.sevenDayForecast?.oneDayForecasts![0].summary ?? "Not available")
        oneWeekSummary.text = "1 week summary: " + (forecast.sevenDayForecast?.summary ?? "Not available")
    }

    private func weatherIcon(iconName: String?) -> String {
        print("Icon: \(iconName)")
        let icon: String
        if let iconName = iconName {
            switch iconName {
            case "clear-day":
                icon = "\u{F00D}"
            case "clear-night":
                icon = "\u{F02E}"
            case "rain":
                icon = "\u{F008}"
            case "snow":
                icon = "\u{F00A}"
            case "sleet":
                icon = "\u{F0B2}"
            case "wind":
                icon = "\u{F085}"
            case "fog":
                icon = "\u{F003}"
            case "cloudy":
                icon = "\u{F002}"
            case "partly-cloudy-day":
                icon = "\u{F002}"
            case "partly-cloudy-night":
                icon = "\u{F081}"
            case "hail":
                icon = "\u{F004}"
            case "thunderstorm":
                icon = "\u{F010}"
            case "tornado":
                icon = "\u{F056}"
            default:
                icon = "\u{F075}"
            }
        } else {
            icon = "\u{F095}"
        }
        return icon
    }

    private func configureUI() {

        currentFrontView.layer.borderWidth = 1
        currentFrontView.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).CGColor
        currentFrontView.layer.cornerRadius = 10
        currentRearView.layer.borderWidth = 1
        currentRearView.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0).CGColor
        currentRearView.layer.cornerRadius = 10

        clockFrontView.layer.borderWidth = 1
        clockFrontView.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).CGColor
        clockFrontView.layer.cornerRadius = 10
        clockRearView.layer.borderWidth = 1
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
        let units = NSUserDefaults.read(key: "units", defaultValue: "auto")
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
        case summaryFlipButton:
            flop(oneWeekView, middleView: oneDayView, rearView: oneHourView)
        default:
            break
        }
    }

    @IBAction func switchUnits(sender: UIButton) {
        switch sender {
        case autoUnits:
            NSUserDefaults.write(key: "units", value: "auto")
        case metricUnits:
            NSUserDefaults.write(key: "units", value: "ca")
        case ukUnits:
            NSUserDefaults.write(key: "units", value: "uk2")
        case usUnits:
            NSUserDefaults.write(key: "units", value: "us")
        default:
            break
        }
        configureUnitButtons()
        updateForecast()
    }
}

// MARK: - Extensions
// MARK: - VOSClockDelegate extension

extension ForecastViewController: VOSClockDelegate {
    
    func currentTime(hours hours: Int, minutes: Int, seconds: Int) {
        timeText = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
