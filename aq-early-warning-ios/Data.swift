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
}

struct AuthResponse: Codable {
    let backendUserId: Int
    let email: String
    let firstName: String
    let lastName: String
    let success: Bool
}

struct UserSettings: Codable {
    let id: Int
    let userId: Int
    let maxAqi: Int?
    let latitude: Double?
    let longitude: Double?
}

struct PollutionResponse: Codable {
    let latitude: Double
    let longitude: Double
    let aqi: Int
    let aqiComponents: PollutionResponseDetail
    let date: Int
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
