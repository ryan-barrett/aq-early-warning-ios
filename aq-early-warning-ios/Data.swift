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

class Api {
    @AppStorage("token") var token: String = ""
    @AppStorage("backendUserId") var backendUserId: Int = -1
    
    func authenticate(payload: AuthPaylaod, completion: @escaping (AuthResponse) -> ()) {
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/authenticate/apple") else { return }
        
        guard let encoded = try? JSONEncoder().encode(payload) else {
            print("Failed to encode auth payload")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if (error != nil) {
                print("we got an error :(", error)
            }
            let res = try! JSONDecoder().decode(AuthResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(res)
            }
        }
        .resume()
    }
    
    func getUserSettings(completion: @escaping (UserSettings) -> ()) {
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/user/\(self.backendUserId)/settings") else { return }
        print("got here 1", self.token)
        
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if (error != nil) {
                print("we got an error :(", error)
            }
            let res = try! JSONDecoder().decode(UserSettings.self, from: data!)
            
            DispatchQueue.main.async {
                completion(res)
            }
        }
        .resume()
    }
    
    func getPollution(latitude: Double, longitude: Double, completion: @escaping (PollutionResponse) -> ()) {
        print("incoming lat", latitude)
        print("incoming long", longitude)
        
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/weather/pollution?latitude=\(String(latitude))&longitude=\(String(longitude))") else { return }
        print("url", url)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if (error != nil) {
                print("we got an error :(", error)
            }
            let res = try! JSONDecoder().decode(PollutionResponse.self, from: data!)
            print("pollution response", res)
            
            DispatchQueue.main.async {
                completion(res)
            }
        }
        .resume()
    }
}
