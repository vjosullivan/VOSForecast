//
//  MainViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, WeatherDelegate {

    // MARK: - Clock properties

    var timeText: String = ""

    internal var hours:   Int = 0
    internal var minutes: Int = 0
    internal var seconds: Int = 0

    // MARK: Panels

    var weatherVC: WeatherViewController?
    var clockVC: ClockViewController?

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
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "weatherSegue" {
            weatherVC = segue.destinationViewController as? WeatherViewController
        } else if segue.identifier == "clockSegue" {
            clockVC = segue.destinationViewController as? ClockViewController
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
    }

    private func configureUI() {

        // Most panels should be able to configure themselves.
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
