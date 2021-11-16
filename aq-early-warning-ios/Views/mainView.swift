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
    @EnvironmentObject var currentView: CurrentView
    
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
        Text("AQI")
            .font(.largeTitle)
            .offset(y: -270)
            .navigationBarTitle(Text("Current Conditions"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .onTapGesture {
                            print("it worked!")
                            self.currentView.view = "settings"
                        }
                        .onAppear {
                            if (self.token == "") {
                                self.currentView.view = "signIn"
                            }
                        }
                }
            }
        
        Text(String(self.currentAqi ?? 0))
            .frame(width: 50)
            .font(.largeTitle)
            .padding()
            .border(Color.white, width: 4)
            .offset(y: -260)
            .onAppear {
                if (self.token == "") {
                    self.currentView.view = "signIn"
                } else {
                    Api().getPollution(latitude: self.latitude ?? -1.0, longitude: self.longitude ?? -1.0) { response in
                        self.currentAqi = response.aqi
                    }
                }
            }
        
        Text("Max Acceptable AQI: " + maxAcceptableAQI)
            .offset(y: -210)
            .onAppear {
                if (self.token == "") {
                    self.currentView.view = "signIn"
                } else {
                    Api().getUserSettings { userSettings in
                        print(userSettings)
                        self.maxAqi = userSettings.maxAqi
                        self.latitude = userSettings.latitude
                        self.longitude = userSettings.longitude
                        print("GOT HERE", self.backendUserId ?? 0)
                        print("GOT HERE2", self.maxAqi ?? 0)
                    }
                }
            }
    }
}
