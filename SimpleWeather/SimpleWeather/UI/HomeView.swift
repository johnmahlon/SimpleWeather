//
//  HomeView.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI
import OpenAI

struct HomeView: View {
    
    @StateObject var locater = Locater()
    @State var forecast: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    let openAI = OpenAI(apiToken: Config.APIKeys.openAI)
    
    var data = """
**Tonight**
Tonight will be mostly cloudy with a low temperature of 63°F. The wind will be coming from the south-southeast at around 5 mph.
"""
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack {
                    HStack {
                        Text(.init(forecast))
                            .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .task(id: locater.coordinates?.id) {
                guard let coordinates = locater.coordinates else {
                    return
                }
                do {
                    let prompt = try await Forecaster.shared.getForecast(x: coordinates.x, y: coordinates.y)
                    
                    let query = ChatQuery(
                        model: .gpt3_5Turbo_16k,
                        messages: [
                            .init(
                                role: .user,
                                content: prompt
                            )
                        ]
                    )
                    
                    do {
                        print("off to OpenAI!!")
                        
                        for try await result in openAI.chatsStream(query: query) {
                            forecast += result.choices.filter {$0.index == 0 }.first!.delta.content ?? "abcdef"
                        }
                        
                    } catch let err {
                        print(err.localizedDescription)
                        forecast = "Error with OpenAI"
                    }
                } catch {
                    // just fail silently
                }
                
            }
            .navigationTitle(locater.name ?? "SimpleWeather")
            .toolbar {
                Button {
                    locater.startLocation()
                    forecast = ""
                } label: {
                    Image(systemName: "location")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            .searchable(text: $locater.searchText, placement: .toolbar)
            .onSubmit(of: .search) {
                forecast = ""
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
