//
//  WeatherAPIBrain.swift
//  Clima
//
//  Created by Евгений Фирман on 28.04.2021.

import UIKit
import CoreLocation

// WeatherManagerDelegate Protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherStruct)
    func didCatchError(error: Error)
}

// Weather API Structure initialization
struct WeatherAPIBrain {
    
    var delegate: WeatherManagerDelegate?
    // Weather API URL
    let WeatherAPI = "https://api.openweathermap.org/data/2.5/find?appid=103c3e8047f010ddc6bb097044974a92&units=metric&q="
    
    // Get city function
    func getCity (city: String){
        let url = "\(WeatherAPI)\(city)"
        weatherAPICall(url)
    }
    
    func weatherAPICall(_ url: String){
        // initializing url
        if let url = URL(string: url){
            // Initializing session
            let session = URLSession(configuration: .default)
            // Task session initialization
            let task = session.dataTask(with: url) {(data, urlResponse, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let safeData = data{
                        if let weather = self.decodeJSON(weatherData: safeData){
                            delegate?.didUpdateWeather(weather: weather)
                        }
                    }
                }
            // Resume session
            task.resume()
        }
    }
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees ){
        let urlString = "https://api.openweathermap.org/data/2.5/find?appid=103c3e8047f010ddc6bb097044974a92&units=metric&lat=\(latitude)&lon=\(longitude)"
            weatherAPICall(urlString)
    }
    func decodeJSON(weatherData: Data) -> WeatherStruct?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherID = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].main.temp
            let name = decodedData.list[0].name
            let weather = WeatherStruct(weatherID: weatherID, name: name, temp: temp)
            return weather
        } catch {
//            self.delegate?.didCatchError(error)
            return nil
        }
        
    }
   
}
    

