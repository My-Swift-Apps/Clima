//
//  WeatherData.swift
//  Clima
//
//  Created by Mero on 2020-04-30.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
//Codable is a compination of both decodable and encodable
struct WeatherData: Codable
{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable
{
    let temp : Double
}

struct Weather: Codable
{
    let description: String
    let id: Int
}
