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

    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var rearView: UIView!

    // Weather view

    @IBOutlet weak var weatherView: CurrentWeatherView!
    @IBOutlet weak var currentSummary: UILabel!
    @IBOutlet weak var currentIcon: UILabel!

    // Temperature view

    @IBOutlet weak var temperatureView: TemperatureView!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentFeelsLike: UILabel!
    @IBOutlet weak var nextLow: UILabel!
    @IBOutlet weak var nextLowLabel: UILabel!
    @IBOutlet weak var nextHigh: UILabel!
    @IBOutlet weak var nextHighLabel: UILabel!
    @IBOutlet weak var temperatureUnits: UILabel!
  //@IBOutlet weak var currentDewPoint: UILabel!

    // Wind view

    @IBOutlet weak var windView: WindView!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windSpeedUnits: UILabel!
    @IBOutlet weak var beaufort: UILabel!
    @IBOutlet weak var windDescription: UISegmentedControl!

    // Rain view

    @IBOutlet weak var rainView: OtherView!
    @IBOutlet weak var rainDescription: UILabel!
    @IBOutlet weak var cloudDescription: UILabel!

    // MARK: Units

    @IBOutlet weak var autoUnits: UIButton!
    @IBOutlet weak var metricUnits: UIButton!
    @IBOutlet weak var ukUnits: UIButton!
    @IBOutlet weak var usUnits: UIButton!

    var parentVC: CurrentWeatherDelegate?

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUnitButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            print("Landscape: size = \(size.width)x\(size.height)")
        } else {
            print("Portrait: size = \(size.width)x\(size.height)")
        }
        weatherView.shouldUpdateSubviews = true
        weatherView.setNeedsDisplay()
        windView.shouldUpdateSubviews = true
        windView.setNeedsDisplay()
        temperatureView.shouldUpdateSubviews = true
        temperatureView.setNeedsDisplay()
        rainView.shouldUpdateSubviews = true
        rainView.setNeedsDisplay()
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

    @IBAction func actionSaveSetting(sender: UISegmentedControl) {
        if sender == windDescription {
            NSUserDefaults.write(key: "windDescription", value: ["words", "numbers"][sender.selectedSegmentIndex])
        }
        parentVC!.updateForecast()
    }


    // MARK: - Functions

    func updateView(forecast: Forecast) {

        currentTemperature!.text = "\(forecast.currentTemperatureDisplay)"
        currentFeelsLike.text   = "\(forecast.currentFeelsLikeDisplay)"
        nextLow.text       = "\(forecast.lowTodayDisplay)"
        if let lowTime = forecast.oneDayForecast?.temperatureMinTime?.asHpm(showMidday: true) {
            nextLowLabel.text  = "Low \(lowTime)"
        } else {
            nextLowLabel.text = "Low"
        }
        nextHigh.text      = "\(forecast.highTodayDisplay)"
        if let highTime = forecast.oneDayForecast?.temperatureMaxTime?.asHpm(showMidday: true) {
            nextHighLabel.text  = "High \(highTime)"
        } else {
            nextHighLabel.text = "High"
        }
        temperatureUnits!.text = "\(forecast.units.temperature)"

        currentSummary.text     = forecast.currentWeather!.summary!
        let direction: Double = forecast.currentWeather!.windBearing!
        if NSUserDefaults.read(key: "windDescription", defaultValue: "numbers") == "words" {
            windDescription.selectedSegmentIndex = 0
            windSpeed.text = ""
            beaufort.text  = BeaufortScale(speed: forecast.currentWeather!.windSpeed!, units: forecast.units.windSpeed).description
            windSpeedUnits.text = "from \(Compass(direction: direction).principleWind)"
        } else {
            windDescription.selectedSegmentIndex = 1
            let speed: Int = Int(round(forecast.currentWeather!.windSpeed!))
            windSpeed.text = "\(speed)"
            beaufort.text  = ""
            windSpeedUnits.text = forecast.units.windSpeed
        }
        windView.windDirection = direction

        let intensity  = Rain.intensity(forecast.currentWeather?.precipIntensity ?? 0.0, units: forecast.flags?.units ?? "")
        let likelyhood = forecast.rainLikelyhoodDisplay
        rainDescription.text = "\(intensity)\n(\(likelyhood) chance)" // \(forecast.currentWeather?.prec
        cloudDescription.text = "Cloud cover: \(forecast.cloudCoverDisplay)"
        print("Timezone: \(forecast.timezone ?? "Unknown").  Offset: \(String(forecast.offset) ?? "Unknown")")
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
        parentVC = parent as? CurrentWeatherDelegate
        parentVC?.updateForecast()
    }
}