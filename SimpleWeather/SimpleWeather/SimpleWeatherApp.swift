//
//  SimpleWeatherApp.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI

@main
struct SimpleWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(forecast: "")
        }
    }
}
