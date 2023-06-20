//
//  HomeView.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI

struct HomeView: View {
    
    @State var forecasts: [Forecast]
    
    var body: some View {
        VStack {
            List {
                ForEach(forecasts) { forecast in
                    WeatherView(forecast: forecast)
                }
            }
            .listStyle(.plain)
            .task {
                do {
                    forecasts = try await NWSAPI
                        .getForecast(x: 36.113, y: -86.925)
                } catch let err {
                    print(err)
                }
                
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(forecasts: [Forecast.sample, Forecast.sample2])
    }
}
