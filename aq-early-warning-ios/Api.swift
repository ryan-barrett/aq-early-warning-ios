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
    @AppStorage("backendToken") var backendToken: String = ""
    
    func authenticate(userId: String, email: String, firstName: String, lastName: String, token: String, completion: @escaping (AuthResponse) -> ()) {
        let uuid = NSUUID().uuidString.lowercased()
        
        let payload = AuthPaylaod(userId: userId, email: email == "" ? "\(uuid)@notreal.com" : email, firstName: firstName == "" ? uuid : firstName, lastName: lastName == "" ? uuid : lastName, token: "Bearer \(token)")
        
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/authenticate") else { return }
        print("AUTH PAYLOAD", payload)
        
        guard let encoded = try? JSONEncoder().encode(payload) else {
            print("Failed to encode auth payload")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
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
        request.addValue("Bearer \(self.backendToken)", forHTTPHeaderField: "authorization")
        
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
        request.addValue("Bearer \(self.backendToken)", forHTTPHeaderField: "authorization")
        
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
    
    func getPollutionForecast(latitude: Double, longitude: Double, completion: @escaping (PollutionForecastResponse) -> ()) {
        print("incoming lat", latitude)
        print("incoming long", longitude)
        
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/weather/pollution/forecast?latitude=\(String(latitude))&longitude=\(String(longitude))") else { return }
        print("url", url)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue("Bearer \(self.backendToken)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if (error != nil) {
                print("we got an error :(", error)
            }
            let res = try! JSONDecoder().decode(PollutionForecastResponse.self, from: data!)
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
        request.addValue("Bearer \(self.backendToken)", forHTTPHeaderField: "authorization")
        
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
        request.addValue("Bearer \(self.backendToken)", forHTTPHeaderField: "authorization")
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
    
    func reverseGeocode(latitude: Double, longitude: Double, completion: @escaping (String) -> ()) {
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/maps/geocode?latitude=\(latitude)&longitude=\(longitude)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(self.backendToken)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if (error != nil) {
                print("we got an error :(", error)
            }
            let res = try! JSONDecoder().decode(ReverseGeocodeResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(res.results.count > 0 ? res.results[0].formattedAddress : "")
            }
        }
        .resume()
    }
    
    func postalCodeSearch(postalCode: Int, completion: @escaping (ReverseGeocodeResult) -> ()) {
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/maps/address?address=\(postalCode)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(self.backendToken)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if (error != nil) {
                print("we got an error :(", error)
            }
            let res = try! JSONDecoder().decode(ReverseGeocodeResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(res.results[0])
            }
        }
        .resume()
    }
}
