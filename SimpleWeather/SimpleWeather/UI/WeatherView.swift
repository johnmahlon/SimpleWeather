//
//  WeatherView.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI

struct WeatherView: View {
    var forecast: Forecast
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(forecast.name)
                    .font(.title)
                
                Text("\(forecast.temperature) \(forecast.temperatureUnit)")
                    .font(.title2)
                
                Text(forecast.detailedForecast)
                    .padding(.top, 16)
            }.padding(32)
            
            Spacer()
        }
       
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(
            forecast: Forecast.sample
        )
    }
}
