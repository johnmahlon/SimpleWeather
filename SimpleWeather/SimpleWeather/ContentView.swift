//
//  ContentView.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView(forecasts: [])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
