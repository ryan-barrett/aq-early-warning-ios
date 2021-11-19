//
//  mainView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/15/21.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
    
    @State var aqiDetails: PollutionResponse = PollutionResponse(latitude: nil, longitude: nil, aqi: nil, aqiComponents: nil, date: nil)
    
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
        ScrollView {
            Text("AQI")
                .font(.largeTitle)
                .padding(EdgeInsets(top: 40, leading: 0, bottom: 10, trailing: 0))
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
                .padding()
                .onAppear {
                    if (self.token == "") {
                        self.currentView.view = "signIn"
                    } else {
                        Api().getUserSettings { userSettings in
                            print("got here user settings", userSettings)
                            self.maxAqi = userSettings.maxAqi
                            self.latitude = userSettings.latitude
                            self.longitude = userSettings.longitude
                            print("GOT HERE", self.backendUserId!)
                            print("GOT HERE2", self.maxAqi ?? 0)
                            
                            Api().getPollution(latitude: self.latitude ?? -1.0, longitude: self.longitude ?? -1.0) { response in
                                self.currentAqi = response.aqi
                                self.aqiDetails = response
                            }
                        }
                    }
                }
            
            Text("Max Acceptable AQI: " + maxAcceptableAQI)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 35, trailing: 0))
            
//            AqiBreakdownView(aqiDetails: self.aqiDetails)
            ForecastView()
        }
    }
}
