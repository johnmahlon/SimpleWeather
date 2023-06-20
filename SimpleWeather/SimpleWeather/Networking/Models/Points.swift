//
//  Points.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import Foundation

struct Points: Decodable {
    let properties: Property
}

struct Property: Decodable {
    let forecast: String
}


