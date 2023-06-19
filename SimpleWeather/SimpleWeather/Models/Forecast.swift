//
//  Forecast.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import Foundation

struct Forecast: Decodable {
    
    let number: Int
    let name: String
    let temperature: Int
    let temperatureUnit: String
    let windSpeed: String
    let detailedForecast: String
    
    static var sample: Forecast {
        do {
            return try JSONDecoder().decode(Forecast.self, from: Data(Forecast.sampleJSON.utf8))
        } catch {
            fatalError("whoops, you messed up buddy")
        }
    }
    
    
    static let sampleJSON: String = """
{
                "number": 1,
                "name": "Juneteenth",
                "startTime": "2023-06-19T16:00:00-05:00",
                "endTime": "2023-06-19T18:00:00-05:00",
                "isDaytime": true,
                "temperature": 80,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": 70
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": 21.666666666666668
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 81
                },
                "windSpeed": "10 mph",
                "windDirection": "WNW",
                "icon": "https://api.weather.gov/icons/land/day/tsra_hi,70?size=medium",
                "shortForecast": "Showers And Thunderstorms Likely",
                "detailedForecast": "Showers and thunderstorms likely. Partly sunny, with a high near 80. West northwest wind around 10 mph. Chance of precipitation is 70%. New rainfall amounts between a tenth and quarter of an inch possible."
            }
"""
}
