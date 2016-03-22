//
//  WeatherManager.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

///  Handles communication with the weather API.
public class ForecastIOManager {
    
    // MARK: - Properties
    
    private let forecastApiKey = "7f7075d90bf85644daa070b898a10132"
    
    // MARK: - Methods
    
    ///  Fetches the weather data and passes it to the supplied handler.
    ///
    public func fetchWeather(latitude latitude: Double, longitude: Double, units: String, handle: (data: NSData?, error: NSError?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        let weatherURL = forecastURL(latitude: latitude, longitude: longitude, units: units)
        let loadDataTask = session.dataTaskWithURL(weatherURL) { (data, response, error) -> Void in
            if let error = error {
                handle(data: nil, error: error)
            } else if let response = response as? NSHTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(
                        domain: "com.vjosullivan",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    handle(data: nil, error: statusError)
                } else {
                    handle(data: data, error: nil)
                }
            }
        }
        loadDataTask.resume()
    }
    
    private func forecastURL(latitude latitude: Double, longitude: Double, units: String) -> NSURL {
        return NSURL(string: "https://api.forecast.io/forecast/\(forecastApiKey)/\(latitude),\(longitude)?units=\(units)")!
    }
}