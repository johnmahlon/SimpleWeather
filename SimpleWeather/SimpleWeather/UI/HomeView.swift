//
//  HomeView.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI

struct HomeView: View {
    
    var forecasts: [Forecast]
    
    var body: some View {
        VStack {
            List {
                ForEach(forecasts) { forecast in
                    WeatherView(forecast: forecast)
                }
            }.listStyle(.plain)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(forecasts: [Forecast.sample, Forecast.sample2])
    }
}
