//
//  WeatherVIewModel.swift
//  Weather App Assgn
//
//  Created by Mayank Jangid on 2/4/25.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    
    //i have not written my api key.... if you want to test the app message me on my email jangid10mayank@gmail.com
    
    private let apiKey = "API_KEY"
    private let cacheKey = "cachedWeather"
    
    func fetchWeather(lat: Double, lon: Double) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API Request Error: \(error.localizedDescription)")
                self.loadCachedWeather()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                self.loadCachedWeather()
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    withAnimation {
                        self.weather = decodedResponse
                    }
                    self.cacheWeather(decodedResponse)
                    self.sendWeatherAlert(weather: decodedResponse)
                }
            } catch {
                print("JSON Decoding Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func cacheWeather(_ weather: WeatherResponse) {
        if let encoded = try? JSONEncoder().encode(weather) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    private func loadCachedWeather() {
        if let savedData = UserDefaults.standard.data(forKey: cacheKey),
           let decodedWeather = try? JSONDecoder().decode(WeatherResponse.self, from: savedData) {
            DispatchQueue.main.async {
                self.weather = decodedWeather
            }
        }
    }
    
    private func sendWeatherAlert(weather: WeatherResponse) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Weather Alert"
        content.body = "Current temperature: \(weather.main.temp)°C, \(weather.weather.first?.description ?? "")"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "weatherAlert", content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}
