//
//  Data.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/11/21.
//

import SwiftUI

struct AuthPaylaod: Codable {
    var userId: String
    var email: String
    var firstName: String
    var lastName: String
    var token: String
}

struct AuthResponse: Codable {
    let jwt: String
    let iosResponse: IosResponse
}

struct IosResponse: Codable {
    let backendUserId: Int
    let email: String
    let firstName: String
    let lastName: String
}
struct UserSettings: Codable {
    let id: Int
    let userId: Int
    let maxAqi: Int?
    let latitude: Double?
    let longitude: Double?
}

class ResponseContainer: ObservableObject, Codable {
    var response: PollutionResponse?
    
    init(response: PollutionResponse) {
        self.response = response
    }
}

class PollutionResponse: ObservableObject, Decodable, Encodable {
    let latitude: Double?
    let longitude: Double?
    let aqi: Int?
    let aqiComponents: PollutionResponseDetail?
    let date: Int?
    
    init(latitude: Double?, longitude: Double?, aqi: Int?, aqiComponents: PollutionResponseDetail?, date: Int?) {
        self.latitude = latitude
        self.longitude = longitude
        self.aqi = aqi
        self.aqiComponents = aqiComponents
        self.date = date
    }
}

struct PollutionForecastCoords: Codable {
    let lon: Double?
    let lat: Double?
}

struct PollutionForecastResponse: Codable {
    let coord: PollutionForecastCoords?
    let latitude: Double?
    let longitude: Double?
    let list: [PollutionForecastEntry]
}

struct PollutionForecastMain: Codable {
    let aqi: Int?
}

struct PollutionForecastEntry: Codable {
    let main: PollutionForecastMain?
    let components: PollutionResponseDetail?
    let dt: Int?
    let aqi: Int?
}

struct PollutionResponseDetail: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double
}

struct ReverseGeocodeResponse: Codable {
    let results: [ReverseGeocodeResult]
}

struct ReverseGeocodeResult: Codable {
    let formattedAddress: String
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: GeometryLocation
}

struct GeometryLocation: Codable {
    let lat: Double
    let lng: Double
}
