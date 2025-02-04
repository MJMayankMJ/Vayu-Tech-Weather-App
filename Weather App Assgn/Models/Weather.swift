//
//  WeatherResponse.swift
//  Weather App Assgn
//
//  Created by Mayank Jangid on 2/4/25.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
}
