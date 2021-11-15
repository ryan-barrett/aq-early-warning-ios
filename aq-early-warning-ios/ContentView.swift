//
//  ContentView.swift
//  aq-early-warning
//
//  Created by Ryan Barrett on 11/11/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    @AppStorage("token") var token: String = ""
    
    @AppStorage("maxAqi") var maxAqi: Int = -1
    @AppStorage("latitude") var latitude: Double = -1.0
    @AppStorage("longitude") var longitude: Double = -1.0
    
    @AppStorage("currentAqi") var currentAqi: Int?
    
//    private var isSignedIn: Bool {
//        !userId.isEmpty
//    }
    
    private var maxAcceptableAQI: String {
        if (self.maxAqi > -1) {
            return String (self.maxAqi)
        }
        else {
            return "Not Set"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.token == "") {
                    SignInView()
                }
                else {
                    Text(self.email)
//                    Text(self.firstName)
//                    Text(self.lastName)
//                    Text(self.userId)
                    Text("Max Acceptable AQI: " + maxAcceptableAQI)
//                    Text(String(self.latitude))
//                    Text(String(self.longitude))
                    Text("Current AQI: " + String(self.currentAqi ?? 0))
                        .onAppear {
                            Api().getPollution(latitude: self.latitude ?? -1.0, longitude: self.longitude ?? -1.0) { response in
                                self.currentAqi = response.aqi

                            }
                        }
                }
            }
            .navigationTitle("Sign In")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
