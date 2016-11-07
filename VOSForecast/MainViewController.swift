//
//  MainViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, WeatherDelegate {

    // MARK: - Clock properties

    var timeText: String = ""

    internal var hours:   Int = 0
    internal var minutes: Int = 0
    internal var seconds: Int = 0

    let padding: CGFloat = 10.0
    let halfPad: CGFloat = 5.0

    // MARK: Location

    let locationManager = CLLocationManager()

    // MARK: Panels

    var weatherVC: WeatherViewController?
    var clockVC: ClockViewController?
    var astrolabeVC: AstrolabeViewController?

    // MARK: - Constraints

    var initialLayout = true

    @IBOutlet weak var constraintClockTop: NSLayoutConstraint!
    @IBOutlet weak var constraintClockBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintClockLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintClockTrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintWeatherTop: NSLayoutConstraint!
    @IBOutlet weak var constraintWeatherBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintWeatherLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintWeatherTrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintAstrolabeTop: NSLayoutConstraint!
    @IBOutlet weak var constraintAstrolabeBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintAstrolabeLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintAstrolabeTrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintRainTop: NSLayoutConstraint!
    @IBOutlet weak var constraintRainBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintRainLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintRainTrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintATop: NSLayoutConstraint!
    @IBOutlet weak var constraintABottom: NSLayoutConstraint!
    @IBOutlet weak var constraintALeading: NSLayoutConstraint!
    @IBOutlet weak var constraintATrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintBTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintBLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintBTrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintCTop: NSLayoutConstraint!
    @IBOutlet weak var constraintCBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintCLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintCTrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintDTop: NSLayoutConstraint!
    @IBOutlet weak var constraintDBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintDLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintDTrailing: NSLayoutConstraint!

    @IBOutlet weak var constraintSummaryTop: NSLayoutConstraint!
    @IBOutlet weak var constraintSummaryBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintSummaryLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintSummaryTrailing: NSLayoutConstraint!

    @IBOutlet weak var locationLine1: UILabel!
    @IBOutlet weak var locationLine2: UILabel!

    // MARK: Summary panel

    @IBOutlet weak var minutelyView: UIView!
    @IBOutlet weak var hourlyView: UIView!
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var minutelySummary: UILabel!
    @IBOutlet weak var hourlySummary: UILabel!
    @IBOutlet weak var dailySummary: UILabel!
    @IBOutlet weak var summaryFlipButton: UIButton!

    // MARK: - UIViewController functions.

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureLocationManager()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherSegue" {
            weatherVC = segue.destination as? WeatherViewController
        } else if segue.identifier == "clockSegue" {
            clockVC = segue.destination as? ClockViewController
        } else if segue.identifier == "astrolabeSegue" {
            astrolabeVC = segue.destination as? AstrolabeViewController
        }

    }

    func flop(_ frontView: UIView, middleView: UIView, rearView: UIView) {
        if !frontView.isHidden {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromBottom, .showHideTransitionViews]
            UIView.transition(with: frontView,  duration: 1.0, options: transitionOptions, animations: { frontView.isHidden  = true  }, completion: nil)
            UIView.transition(with: middleView, duration: 1.0, options: transitionOptions, animations: { middleView.isHidden = false }, completion: nil)
        } else if !middleView.isHidden {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromBottom, .showHideTransitionViews]
            UIView.transition(with: middleView, duration: 1.0, options: transitionOptions, animations: { middleView.isHidden = true  }, completion: nil)
            UIView.transition(with: rearView,   duration: 1.0, options: transitionOptions, animations: { rearView.isHidden   = false }, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromBottom, .showHideTransitionViews]
            UIView.transition(with: rearView,   duration: 1.0, options: transitionOptions, animations: { rearView.isHidden   = true  }, completion: nil)
            UIView.transition(with: frontView,  duration: 1.0, options: transitionOptions, animations: { frontView.isHidden  = false }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Local functions

    func updateForecast() {
        locationManager.requestLocation()
    }

    fileprivate func updateView(_ forecast: Forecast) {

        minutelySummary.text =  "1 hour summary:  " + (forecast.minutely?.summary ?? "Not available")
        hourlySummary.text   = "24 hour summary:  " + (forecast.hourly?.summary ?? "Not available")
        dailySummary.text    =  "1 week summary:  " + (forecast.daily?.summary ?? "Not available")

        clockVC!.highlightColor = forecast.highlightColor
    }

    fileprivate func configureUI() {
        setConstraints(orientation: UIApplication.shared.statusBarOrientation)
    }

    @IBAction func flipPanel(_ sender: UIButton) {
        switch sender {
        case summaryFlipButton:
            flop(dailyView, middleView: hourlyView, rearView: minutelyView)
        default:
            break
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {

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
        if let coords = manager.location?.coordinate,
            let location = manager.location {
            let units = UserDefaults.read(key: WeatherKeys.units, defaultValue: "auto")
            print("Fetching forecast at \(coords.latitude), \(coords.longitude) in \(units).  Altitude \(location.altitude)")
            ForecastIOManager().fetchWeather(latitude: coords.latitude, longitude: coords.longitude, units: units) {(data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        if let forecast = Forecast(data: data) {
                            print("Forecast: \(forecast)")
                            self.updateView(forecast)
                            self.weatherVC!.updateView(forecast)
                            if let today = forecast.today {
                                self.astrolabeVC!.updateView(today)
                            }
                        } else {
                            let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available pent.", preferredStyle: .alert)
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
            updateLocationLabel(location)
        } else {
            print("Unable to determine location.")
        }
    }

    fileprivate func updateLocationLabel(_ location: CLLocation) {
        let latitude  = round(location.coordinate.latitude * 10.0) / 10.0
        let longitude = round(location.coordinate.longitude * 10.0) / 10.0
        let altitude  = round(location.altitude * 10.0) / 10.0
        let latitudeSuffix  = latitude >= 0.0 ? "°N" : "°S"
        let longitudeSuffix = longitude >= 0.0 ? "°E" : "°W"
        locationLine1.text = "\(abs(latitude))\(latitudeSuffix)  \(abs(longitude))\(longitudeSuffix)"
        locationLine2.text = "altitude: \(altitude)m"
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLONK!")
    }
}
