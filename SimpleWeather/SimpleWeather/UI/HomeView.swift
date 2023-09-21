//
//  HomeView.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var locater = Locater()
    @State var forecast: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    var data = """
**Tonight**
Tonight will be mostly cloudy with a low temperature of 63°F. The wind will be coming from the south-southeast at around 5 mph.
"""
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVStack {
                    Text(.init(forecast))
                        .padding(.horizontal, 16)
                    Spacer()
                }
            }
            .task(id: locater.coordinates?.id) {
                guard let coordinates = locater.coordinates else {
                    return
                }
                
                forecast = await Forecaster.shared.getForecast(x: coordinates.x, y: coordinates.y)
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
            .searchable(text: $locater.searchText, placement: .toolbar)
            .onSubmit(of: .search) {
                locater.searchLocation(locationName: locater.searchText)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(forecast: "Hello, world..")
    }
}
