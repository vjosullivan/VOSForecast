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

    // MARK: Summary panel

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

        configureUI()
        configureLocationManager()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "weatherSegue" {
            weatherVC = segue.destinationViewController as? WeatherViewController
        } else if segue.identifier == "clockSegue" {
            clockVC = segue.destinationViewController as? ClockViewController
        } else if segue.identifier == "astrolabeSegue" {
            astrolabeVC = segue.destinationViewController as? AstrolabeViewController
        }

    }

    func flop(frontView: UIView, middleView: UIView, rearView: UIView) {
        if !frontView.hidden {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .ShowHideTransitionViews]
            UIView.transitionWithView(frontView,  duration: 1.0, options: transitionOptions, animations: { frontView.hidden  = true  }, completion: nil)
            UIView.transitionWithView(middleView, duration: 1.0, options: transitionOptions, animations: { middleView.hidden = false }, completion: nil)
        } else if !middleView.hidden {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .ShowHideTransitionViews]
            UIView.transitionWithView(middleView, duration: 1.0, options: transitionOptions, animations: { middleView.hidden = true  }, completion: nil)
            UIView.transitionWithView(rearView,   duration: 1.0, options: transitionOptions, animations: { rearView.hidden   = false }, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .ShowHideTransitionViews]
            UIView.transitionWithView(rearView,   duration: 1.0, options: transitionOptions, animations: { rearView.hidden   = true  }, completion: nil)
            UIView.transitionWithView(frontView,  duration: 1.0, options: transitionOptions, animations: { frontView.hidden  = false }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Local functions

    func updateForecast() {
        let units = NSUserDefaults.read(key: WeatherKeys.units, defaultValue: "auto")
        let latitude  = 51.3
        let longitude = -1.0
        print("Fetching forecast at \(latitude), \(longitude) in \(units).")
        ForecastIOManager().fetchWeather(latitude: latitude, longitude: longitude, units: units) {(data, error) in
            if let data = data {
                dispatch_async(dispatch_get_main_queue()) {
                    if let forecast = ForecastIOBuilder().buildForecast(data) {
                        self.updateView(forecast)
                        self.weatherVC!.updateView(forecast)
                        if let today = forecast.oneDayForecast {
                            self.astrolabeVC!.updateView(today)
                        }
                    } else {
                        let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available at the moment.", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(okAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            if let error = error {
                print("ERROR: \(error.description)")
            }
        }
    }

    private func updateView(forecast: Forecast) {

        oneHourSummary.text = "1 hour summary: " + (forecast.sixtyMinuteForecast?.summary ?? "Not available")
        oneDaySummary.text  = "24 hour summary:  " + (forecast.sevenDayForecast?.oneDayForecasts![0].summary ?? "Not available")
        oneWeekSummary.text = "1 week summary: " + (forecast.sevenDayForecast?.summary ?? "Not available")

        clockVC!.highlightColor = forecast.highlightColor
    }

    private func configureUI() {

        let orientation = UIApplication.sharedApplication().statusBarOrientation

        if orientation.isPortrait {
            // Portrait
            print("Starting in portrait.")
        } else {
            // Landscape
            print("Starting in landscape.")
        }
        setConstraints(orientation)
    }

    @IBAction func flipPanel(sender: UIButton) {
        switch sender {
        case summaryFlipButton:
            flop(oneWeekView, middleView: oneDayView, rearView: oneHourView)
        default:
            break
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {

    private func configureLocationManager() {
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

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Wahey!")
        if let locValue = manager.location?.coordinate {
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            let alertController = UIAlertController(title: "Current Location", message: "Latitude: \(locValue.latitude)\nLongitude: \(locValue.longitude)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)

        } else {
            print("Unable to determine location.")
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("CLONK!")
    }
}
