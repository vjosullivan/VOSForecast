//
//  WeatherManager.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

///  Handles communication with the weather API.
open class ForecastIOManager {
    
    // MARK: - Properties
    
    fileprivate let forecastApiKey = "7f7075d90bf85644daa070b898a10132"
    
    // MARK: - Methods
    
    ///  Fetches the weather data and passes it to the supplied handler.
    ///
    open func fetchWeather(latitude: Double, longitude: Double, units: String, handle: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        
        let session = URLSession.shared
        let weatherURL = forecastURL(latitude: latitude, longitude: longitude, units: units)
        let loadDataTask = session.dataTask(with: weatherURL, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                handle(nil, error as NSError?)
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(
                        domain: "com.vjosullivan",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    handle(nil, statusError)
                } else {
                    handle(data, nil)
                }
            }
        }) 
        loadDataTask.resume()
    }
    
    fileprivate func forecastURL(latitude: Double, longitude: Double, units: String) -> URL {
        return URL(string: "https://api.forecast.io/forecast/\(forecastApiKey)/\(latitude),\(longitude)?units=\(units)")!
    }
}
