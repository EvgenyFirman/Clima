//
//  WeatherStruct.swift
//  Clima
//
//  Created by Евгений Фирман on 30.04.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherStruct{
    let weatherID: Int
    let name: String
    let temp: Double
    var temperature: String {
        return String(format: "%.1f",temp)
    }
   
    var computedValue: String{
        switch weatherID {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }
    }
}
