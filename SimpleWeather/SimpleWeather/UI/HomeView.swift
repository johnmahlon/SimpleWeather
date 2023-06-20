//
//  HomeView.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @StateObject var locater = Locater()
    @State var forecasts: [Forecast]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                List {
                    ForEach(forecasts) { forecast in
                        WeatherView(forecast: forecast)
                    }
                }
                .listStyle(.automatic)
                .task(id: locater.coordinates?.id) {
                    do {
                        guard let coordinates = locater.coordinates else {
                            return
                        }
                        
                        forecasts = try await NWSAPI
                            .getForecast(x: coordinates.x, y: coordinates.y)
                    } catch let err {
                        print(err)
                    }
                    
                }
                
            }
            .navigationTitle(locater.name ?? "SimpleWeather")
            .toolbar {
                Button {
                    locater.startLocation()
                } label: {
                    Image(systemName: "location")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
        .searchable(text: $locater.searchText, placement: .toolbar)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(forecasts: [Forecast.sample, Forecast.sample2])
    }
}
