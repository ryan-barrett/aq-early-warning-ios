//
//  Data.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/11/21.
//

import SwiftUI

struct AuthPaylaod: Codable {
    var userId: String
    var token: String
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

class Api {
    func authenticate(payload: AuthPaylaod, completion: @escaping (AuthResponse) -> ()) {
        guard let url = URL(string: "https://boiling-chamber-50753.herokuapp.com/authenticate/apple") else { return }
        
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
            print("got here auth", res)
            
            DispatchQueue.main.async {
                completion(res)
            }
        }
        .resume()
    }
}
