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

    // MARK: - UIViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()

        print("It did!")
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

        dispatch_async(dispatch_get_main_queue()) {
        print(self.currentTemperature!.text)
        self.currentTemperature!.text = "\(forecast.currentTemperatureDisplay)"
        self.currentFeelsLike.text   = "Feels like:  \(forecast.currentFeelsLikeDisplay)"
        self.currentDewPoint.text    = "Dew point:  \(forecast.currentDewPointDisplay)"
        self.currentSummary.text     = forecast.currentWeather?.summary
        }
    }

    private func flipViews(frontView: UIView, rearView: UIView) {
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
}
