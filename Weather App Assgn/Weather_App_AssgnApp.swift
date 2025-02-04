//
//  Weather_App_AssgnApp.swift
//  Weather App Assgn
//
//  Created by Mayank Jangid on 2/1/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(weatherViewModel)
        }
    }
}
