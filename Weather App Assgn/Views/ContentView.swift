//
//  ContentView.swift
//  Weather App Assgn
//
//  Created by Mayank Jangid on 2/1/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let weather = weatherViewModel.weather {
                    VStack(spacing: 16) {
                        Image(systemName: "cloud.sun.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.yellow)
                        
                        Text("Temperature: \(weather.main.temp, specifier: "%.1f")°C")
                            .font(.title)
                            .bold()
                        
                        Text("Humidity: \(weather.main.humidity)%")
                            .font(.subheadline)
                        
                        Text(weather.weather.first?.description.capitalized ?? "")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    ProgressView("Fetching Weather...")
                }
            }
            .onAppear {
                if let location = locationManager.userLocation {
                    weatherViewModel.fetchWeather(lat: location.latitude, lon: location.longitude)
                }
            }
            .navigationTitle("Weather Forecast")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
}
