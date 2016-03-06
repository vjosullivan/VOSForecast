//
//  ForecastViewController.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, CurrentWeatherVCDelegate {

    // MARK: - Clock properties
    
    @IBOutlet weak var mainClock: VOSClockView!
    
    var timeText: String = ""
    
    internal var hours:   Int = 0
    internal var minutes: Int = 0
    internal var seconds: Int = 0
    
    // MARK: - Outlets

    // MARK: Clock panel

    @IBOutlet weak var clockView: UIView!
    @IBOutlet weak var clockFrontView: UIView!
    @IBOutlet weak var clockRearView: UIView!
    @IBOutlet weak var clockFlipButton: UIButton!

    // MARK: Current weather panel

    var currentWeatherVC: CurrentWeatherViewController?

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
        updateForecast()
    
        // Configure main clock.
        mainClock.delegate = self
}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "currentWeatherSegue" {
            currentWeatherVC = segue.destinationViewController as? CurrentWeatherViewController
        }
    }

    func flip(frontView: UIView, rearView: UIView) {
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
        let units = NSUserDefaults.read(key: "units", defaultValue: "auto")
        let latitude  = 51.3
        let longitude = -1.0
        print("Fetching forecast at \(latitude), \(longitude) in \(units).")
        ForecastReceiver().fetchWeather(latitude: latitude, longitude: longitude, units: units) {(data, error) in
            if let data = data {
                dispatch_async(dispatch_get_main_queue()) {
                    if let forecast = ForecastBuilder().buildForecast(data) {
                        self.updateView(forecast)
                        self.currentWeatherVC!.updateView(forecast)
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

    }

    @IBAction func flipPanel(sender: UIButton) {
        switch sender {
        case clockFlipButton:
            flip(clockFrontView, rearView: clockRearView)
        case summaryFlipButton:
            flop(oneWeekView, middleView: oneDayView, rearView: oneHourView)
        default:
            break
        }
    }

}

// MARK: - Extensions
// MARK: - VOSClockDelegate extension

extension ForecastViewController: VOSClockDelegate {
    
    func currentTime(hours hours: Int, minutes: Int, seconds: Int) {
        timeText = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        print(timeText)
    }
}
