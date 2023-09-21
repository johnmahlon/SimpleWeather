//
//  Forecaster.swift
//  SimpleWeather
//
//  Created by John Peden on 9/20/23.
//

import Foundation
import OpenAI

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
    
    let openAI = OpenAI(apiToken: Config.APIKeys.openAI)

    func getForecast(x: Double, y: Double) async -> String {
        do {
            let forecasts = try await NWSAPI.getForecast(x: x, y: y)
        
            do {
                let jsonData = try JSONEncoder().encode(forecasts)
                guard let json = String(data: jsonData, encoding: .utf8) else {
                    return "Error converting Data to String"
                }
                
                let query = ChatQuery(
                    model: .gpt3_5Turbo_16k,
                    messages: [
                        .init(
                            role: .user,
                            content: preprompt + json
                        )
                    ]
                )
                
                do {
                    print("off to OpenAI!!")
                    let response = try await openAI.chats(query: query)
                    return response.choices.filter { $0.index == 0 }.first!.message.content ?? "No content??"
                    
                } catch let err {
                    print(err.localizedDescription)
                    return "Error with OpenAI"
                }
            } catch {
                return "Error encoding JSON"
            }
        } catch {
            return ""
        }
    }
}
