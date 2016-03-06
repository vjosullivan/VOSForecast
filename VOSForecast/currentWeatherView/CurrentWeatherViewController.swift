//
//  CurrentWeatherViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 05/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var frontFlipButton: UIButton!
    @IBOutlet weak var rearFlipButton: UIButton!

    @IBOutlet weak var frontView: CurrentWeatherView!
    @IBOutlet weak var rearView: UIView!

    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentFeelsLike: UILabel!
    @IBOutlet weak var currentDewPoint: UILabel!
    @IBOutlet weak var currentSummary: UILabel!
    @IBOutlet weak var currentIcon: UILabel!

    // MARK: Units

    @IBOutlet weak var autoUnits: UIButton!
    @IBOutlet weak var metricUnits: UIButton!
    @IBOutlet weak var ukUnits: UIButton!
    @IBOutlet weak var usUnits: UIButton!

    var parentVC: CurrentWeatherVCDelegate?

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUnitButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions

    @IBAction func flipPanel(sender: UIButton) {
        switch sender {
        case frontFlipButton, rearFlipButton:
            flipViews(frontView, rearView: rearView)
        default:
            break
        }
    }

    // MARK: - Functions

    func updateView(forecast: Forecast) {

        currentTemperature!.text = "\(forecast.currentTemperatureDisplay)"
        currentFeelsLike.text   = "Feels like:  \(forecast.currentFeelsLikeDisplay)"
        currentDewPoint.text    = "Dew point:  \(forecast.currentDewPointDisplay)"
        currentSummary.text     = forecast.currentWeather?.summary

        currentIcon.text = weatherIcon(forecast.currentWeather?.icon)
        if currentIcon.text == "\u{F00D}" {
            currentIcon.textColor = UIColor.yellowColor()
        } else {
            currentIcon.textColor = UIColor.whiteColor()
        }
    }

    private func weatherIcon(iconName: String?) -> String {
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
                let alertController = UIAlertController(title: "Current Weather", message: "No icon found for weather condition: '\(iconName).\n\nHence the 'alien' face.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                presentViewController(alertController, animated: true, completion: nil)
                icon = "\u{F075}"
            }
        } else {
            let alertController = UIAlertController(title: "Current Weather", message: "No weather condition icon selector supplied by the forecast.  Hence the circle.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
            icon = "\u{F095}"
        }
        return icon
    }


    private func flipViews(frontView: UIView, rearView: UIView) {
        if rearView.hidden {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromRight, .ShowHideTransitionViews]
            UIView.transitionWithView(frontView, duration: 1.0, options: transitionOptions, animations: { frontView.hidden = true  }, completion: nil)
            UIView.transitionWithView(rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.hidden  = false }, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromLeft, .ShowHideTransitionViews]
            UIView.transitionWithView(rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.hidden  = true  }, completion: nil)
            UIView.transitionWithView(frontView, duration: 1.0, options: transitionOptions, animations: { frontView.hidden = false }, completion: nil)
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
        parentVC!.updateForecast()
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

    override func didMoveToParentViewController(parent: UIViewController?) {
        parentVC = parent as? CurrentWeatherVCDelegate
        parentVC?.updateForecast()
    }
}

protocol CurrentWeatherVCDelegate {

    func updateForecast()
}
