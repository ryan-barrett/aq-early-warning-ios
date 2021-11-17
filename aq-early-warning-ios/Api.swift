//
//  Data.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/11/21.
//

import SwiftUI

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
        print("fetching settings for ", self.backendUserId)
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
    
    func updateUserMaxAqi(userId: Int, maxAqi: Int, completion: @escaping (UserSettings) -> ()) {
        print("setting maxAqi", maxAqi)
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/user/\(userId)/settings/maxAqi/\(maxAqi)") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
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
    
    func updateUserLocation(userId: Int, latitude: Double, longitude: Double, completion: @escaping (UserSettings) -> ()) {
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/user/\(userId)/settings/location") else { return }
        let payload = UserSettings(id: 0, userId: userId, maxAqi: nil, latitude: latitude, longitude: longitude)
        
        guard let encoded = try? JSONEncoder().encode(payload) else {
            print("Failed to encode auth payload")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "authorization")
        request.httpBody = encoded
        
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
}
