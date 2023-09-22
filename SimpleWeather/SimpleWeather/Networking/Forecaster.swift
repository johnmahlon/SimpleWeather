//
//  Forecaster.swift
//  SimpleWeather
//
//  Created by John Peden on 9/20/23.
//

import Foundation

struct Forecaster {
    
    static let preprompt = """
Creatively summarize the weather JSON using Markdown.

Follow this example for formatting:
**Today**
<SUMMARY>

**Saturday**
<SUMMARY>

**Saturday Night**
<SUMMARY>
\n\n
"""
    
    static let shared = Forecaster()

    func getForecast(x: Double, y: Double) async throws -> String {
        
        let forecasts = try await NWSAPI.shared.getForecast(x: x, y: y)
        
        let jsonData = try JSONEncoder().encode(Array(forecasts[..<5]))
        guard let json = String(data: jsonData, encoding: .utf8) else {
            return "Error converting Data to String"
        }
        
        return json
    }
}
