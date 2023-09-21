//
//  NWSAPI.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import Foundation

enum NWSAPIError: Error {
    case pointsURLInvalid
    case pointsRequestFailed
    case pointsDecodingFailed
    
    case forecastURLInvalid
    case forecastRequestFailed
    case forecastDecodingFailed
}

class NWSAPI {
    
    static let baseURL = "https://api.weather.gov/"
    static let shared = NWSAPI()
    
    private func getForecastURL(x: Double, y: Double) async throws -> String {
        
        guard let url = URL(string: "\(NWSAPI.baseURL)/points/\(x),\(y)") else {
            throw NWSAPIError.pointsURLInvalid
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: NWSAPI.createRequest(for: url, method: "GET"))
        
            do {
                let decoded = try JSONDecoder().decode(Points.self, from: data)
                return decoded.properties.forecast
                
            } catch let err {
                print(err)
                throw NWSAPIError.pointsDecodingFailed
            }
        } catch let err {
            print(err)
            throw NWSAPIError.pointsRequestFailed
        }
    }
    
    func getForecast(x: Double, y: Double) async throws -> [Forecast] {
        
        do {
            let urlString = try await getForecastURL(x: x, y: y)
            guard let url = URL(string: urlString) else {
                throw NWSAPIError.forecastURLInvalid
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(for: NWSAPI.createRequest(for: url, method: "GET"))
                
                do {
                    let decoded = try JSONDecoder().decode(Forecasts.self, from: data)
                    return decoded.properties.periods
                } catch let err {
                    print(err)
                    throw NWSAPIError.forecastDecodingFailed
                }
            } catch let err {
                print(err)
                throw NWSAPIError.forecastRequestFailed
            }

        } catch let err {
            print(err)
            throw NWSAPIError.forecastURLInvalid
        }
    }
    
    static func createRequest(for url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("SimpleWeather, john.peden@protonmail.com", forHTTPHeaderField: "User-Agent")
        return request
    }
}
