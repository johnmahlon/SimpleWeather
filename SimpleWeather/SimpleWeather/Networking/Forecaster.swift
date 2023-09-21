//
//  Forecaster.swift
//  SimpleWeather
//
//  Created by John Peden on 9/20/23.
//

import Foundation

struct Forecaster {
    
    let preprompt = """
You are an expert meteorologist. Summarize the weather JSON using Markdown in your output. If there is a chance of rain, include ☔️  in the title. If there is not rain or a chance of rain, do not include ☔️.

Follow this example for formatting:
**Today**
Tonight will be mostly cloudy with a low temperature of 63°F. The wind will be coming from the south-southeast at around 5 mph.

**Tonight** ☔️
Tonight will be mostly clear with a low temperature of 61°F. The wind will be light, ranging from 0 to 5 mph. There is a chance of rain. \n\n
"""
    
    static let shared = Forecaster()

    func getForecast(x: Double, y: Double) async throws -> String {
        
        let forecasts = try await NWSAPI.shared.getForecast(x: x, y: y)
        
        
        let jsonData = try JSONEncoder().encode(forecasts)
        guard let json = String(data: jsonData, encoding: .utf8) else {
            return "Error converting Data to String"
        }
        
        return preprompt + json
    }
}
