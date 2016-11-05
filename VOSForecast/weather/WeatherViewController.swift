//
//  WeatherViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 05/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

struct WeatherKeys {
    static let units    = "weather.units"
    static let windType = "weather.windtype"
}


class WeatherViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var frontFlipButton: UIButton!
    @IBOutlet weak var rearFlipButton: UIButton!

    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var rearView: UIView!

    // Weather view

    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var currentSummary: UILabel!
    @IBOutlet weak var rainSummary: UILabel!
    @IBOutlet weak var cloudSummary: UILabel!
    @IBOutlet weak var currentIcon: UILabel!

    @IBOutlet weak var weatherIcon: UIImageView!
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

    @IBOutlet weak var rainView: RainView!
    @IBOutlet weak var rainDescription: UILabel!
    @IBOutlet weak var cloudDescription: UILabel!

    // MARK: Units

    @IBOutlet weak var autoUnits: UIButton!
    @IBOutlet weak var metricUnits: UIButton!
    @IBOutlet weak var ukUnits: UIButton!
    @IBOutlet weak var usUnits: UIButton!

    var parentVC: WeatherDelegate?

    // MARK: Location

    let locationManager = CLLocationManager()

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUnitButtons()
        configureLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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

    @IBAction func flipPanel(_ sender: UIButton) {
        switch sender {
        case frontFlipButton, rearFlipButton:
            flipViews(frontView, rearView: rearView)
        default:
            break
        }
    }

    @IBAction func actionSaveSetting(_ sender: UISegmentedControl) {
        if sender == windDescription {
            UserDefaults.write(key: WeatherKeys.windType, value: ["words", "numbers"][sender.selectedSegmentIndex])
        }
        updateForecast()
    }


    // MARK: - Functions

    func updateView(_ forecast: Forecast) {

        guard let units = forecast.flags?.units else {
            return
        }
        let temperatureColor: UIColor
        if let temperature = forecast.currently?.temperature?.value {
            temperatureColor = ColorWheel.colorFor(temperature, unit: units)
            currentTemperature!.text = "\(forecast.currentTemperatureDisplay)"
            currentTemperature.textColor = temperatureColor
        } else {
            temperatureColor = UIColor.white
        }
        if let temperature = forecast.currently?.apparentTemperature?.value {
            currentFeelsLike.text = "\(forecast.currentFeelsLikeDisplay)"
            currentFeelsLike.textColor = ColorWheel.colorFor(temperature, unit: units)
        }
        if let _ = forecast.today?.temperatureMin {
            nextLow.text      = "\(forecast.lowTodayDisplay)"
            nextLow.textColor = temperatureColor
        }
        if let lowTime = forecast.today?.temperatureMinTime?.asHpm(showMidday: true) {
            nextLowLabel.text  = "Low \(lowTime)"
        } else {
            nextLowLabel.text = "Low"
        }
        if let _ = forecast.today?.temperatureMax {
            nextHigh.text      = "\(forecast.highTodayDisplay)"
            nextHigh.textColor = temperatureColor
        }
        if let highTime = forecast.today?.temperatureMaxTime?.asHpm(showMidday: true) {
            nextHighLabel.text  = "High \(highTime)"
        } else {
            nextHighLabel.text = "High"
        }
        temperatureUnits!.text = "\(forecast.units.temperature)"
        temperatureUnits!.textColor = temperatureColor

        currentSummary.text = forecast.currently!.summary!
        cloudSummary.text   = "Clouds: \(forecast.cloudCoverDisplay)"
        let intensity  = Rain.intensity(forecast.currently?.precipIntensity ?? 0.0, units: forecast.flags?.units ?? "")
        rainSummary.text    = "Rain: \(forecast.rainLikelyhoodDisplay) (\(intensity))"
        let direction: Double = forecast.currently!.windBearing!
        if UserDefaults.read(key: WeatherKeys.windType, defaultValue: "numbers") == "words" {
            windDescription.selectedSegmentIndex = 0
            windSpeed.text = ""
            beaufort.text  = BeaufortScale(speed: forecast.currently!.windSpeed!, units: forecast.units.windSpeed.symbol).description
            windSpeedUnits.text = "from \(Compass(direction: direction).principleWind)"
        } else {
            windDescription.selectedSegmentIndex = 1
            let speed: Int = Int(round(forecast.currently!.windSpeed!))
            windSpeed.text = "\(speed)"
            beaufort.text  = ""
            windSpeedUnits.text = forecast.units.windSpeed.symbol
        }
        beaufort.textColor       = temperatureColor
        windSpeedUnits.textColor = temperatureColor
        windSpeed.textColor      = temperatureColor
        windView.windDirection = direction

        if let p = forecast.today?.pressure {
            rainDescription.text  = "Pressure: \(Int(round(p)))mb"
        }
        if let h = forecast.today?.humidity {
            cloudDescription.text = "Humidity: \(Int(round(h * 100.0)))%"
        }
//        currentIcon.text = weatherIcon(forecast.weather?.icon)
//        if currentIcon.text == "\u{F00D}" {
//            currentIcon.textColor = UIColor.yellowColor()
//        } else {
//            currentIcon.textColor = UIColor.whiteColor()
//        }
        weatherIcon.image = weatherImage(forecast.currently?.icon)
    }

    fileprivate func weatherImage(_ iconName: String?) -> UIImage {
        let image: UIImage
        if let iconName = iconName {
            switch iconName {
            case "clear-day":
                image = UIImage(named: "sun")!
            case "clear-night":
                image = UIImage(named: "moon")!
            case "rain":
                image = UIImage(named: "sun")!
            case "snow":
                image = UIImage(named: "snow")!
            case "sleet":
                image = UIImage(named: "sleet")!
            case "wind":
                image = UIImage(named: "wind")!
            case "fog":
                image = UIImage(named: "fog")!
            case "cloudy":
                image = UIImage(named: "cloudy")!
            case "partly-cloudy-day":
                image = UIImage(named: "partly cloudy day")!
            case "partly-cloudy-night":
                image = UIImage(named: "partly cloudy night")!
            case "hail":
                image = UIImage(named: "hail")!
            case "thunderstorm":
                image = UIImage(named: "thunderstorm")!
            case "tornado":
                image = UIImage(named: "tornado")!
            default:
                let alertController = UIAlertController(title: "Current Weather", message: "No icon found for weather condition: '\(iconName).\n\nHence the 'alien' face.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                image = UIImage(named: "sun.png")!
            }
        } else {
            let alertController = UIAlertController(title: "Current Weather", message: "No weather condition icon selector supplied by the forecast.  Hence the circle.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            image = UIImage(named: "sun.png")!
        }
        return image
    }
    fileprivate func weatherIcon(_ iconName: String?) -> String {
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
                let alertController = UIAlertController(title: "Current Weather", message: "No icon found for weather condition: '\(iconName).\n\nHence the 'alien' face.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                icon = "\u{F075}"
            }
        } else {
            let alertController = UIAlertController(title: "Current Weather", message: "No weather condition icon selector supplied by the forecast.  Hence the circle.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            icon = "\u{F095}"
        }
        return icon
    }


    fileprivate func flipViews(_ frontView: UIView, rearView: UIView) {
        if rearView.isHidden {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions, animations: { frontView.isHidden = true  }, completion: nil)
            UIView.transition(with: rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.isHidden  = false }, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(with: rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.isHidden  = true  }, completion: nil)
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions, animations: { frontView.isHidden = false }, completion: nil)
        }
    }

    @IBAction func switchUnits(_ sender: UIButton) {
        switch sender {
        case autoUnits:
            UserDefaults.write(key: WeatherKeys.units, value: "auto")
        case metricUnits:
            UserDefaults.write(key: WeatherKeys.units, value: "ca")
        case ukUnits:
            UserDefaults.write(key: WeatherKeys.units, value: "uk2")
        case usUnits:
            UserDefaults.write(key: WeatherKeys.units, value: "us")
        default:
            break
        }
        configureUnitButtons()
        updateForecast()
    }

    fileprivate func configureUnitButtons() {
        let black = UIColor.black
        let green = UIColor(red: 144.0/255.0, green: 212.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        autoUnits.setTitleColor(black, for: UIControlState())
        metricUnits.setTitleColor(black, for: UIControlState())
        ukUnits.setTitleColor(black, for: UIControlState())
        usUnits.setTitleColor(black, for: UIControlState())
        let units = UserDefaults.read(key: WeatherKeys.units, defaultValue: "auto")
        switch units {
        case "auto":
            autoUnits.setTitleColor(green, for: UIControlState())
        case "ca":
            metricUnits.setTitleColor(green, for: UIControlState())
        case "uk2":
            ukUnits.setTitleColor(green, for: UIControlState())
        case "us":
            usUnits.setTitleColor(green, for: UIControlState())
        default:
            break
        }
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        updateForecast()
    }
}

extension WeatherViewController: WeatherDelegate {
    func updateForecast() {
        locationManager.requestLocation()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {

    fileprivate func configureLocationManager() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()

        // For use in foreground
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Wahey!")
        if let coords = manager.location?.coordinate,
            let location = manager.location {
            let units = UserDefaults.read(key: WeatherKeys.units, defaultValue: "auto")
            print("Fetching forecast at \(coords.latitude), \(coords.longitude) in \(units).  Altitude \(location.altitude)")
            ForecastIOManager().fetchWeather(latitude: coords.latitude, longitude: coords.longitude, units: units) {(data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        if let forecast = Forecast(data: data) {
                            self.updateView(forecast)
                        } else {
                            let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available at the moment.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                if let error = error {
                    print("ERROR: \(error.description)")
                }
            }
        } else {
            print("Unable to determine location.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("WeatherView clonk!")
    }
}
