//
//  mainView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/15/21.
//

import SwiftUI

struct MainView: View {
    @AppStorage("backendUserId") var backendUserId: Int?
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    @AppStorage("token") var token: String = ""
    
    @AppStorage("maxAqi") var maxAqi: Int?
    @AppStorage("latitude") var latitude: Double?
    @AppStorage("longitude") var longitude: Double?
    
    @AppStorage("currentAqi") var currentAqi: Int?
    
    private var maxAcceptableAQI: String {
        let aqi = self.maxAqi ?? -1
        if (aqi > -1) {
            return String(aqi)
        }
        else {
            return "Not Set"
        }
    }
    
    var body: some View {
        Image(systemName: "gearshape.fill")
            .font(.title)
            .offset(x: 180, y: -335)
            .padding()
        
        Text("Current AQI")
            .font(.largeTitle)
            .offset(y: -310)
        
        Text(String(self.currentAqi ?? 0))
            .frame(width: 50)
            .font(.largeTitle)
            .padding()
            .border(Color.white, width: 4)
            .offset(y: -290)
            .onAppear {
                Api().getPollution(latitude: self.latitude ?? -1.0, longitude: self.longitude ?? -1.0) { response in
                    self.currentAqi = response.aqi
                }
            }
        
        Text("Max Acceptable AQI: " + maxAcceptableAQI)
            .offset(y: -240)
    }
}
