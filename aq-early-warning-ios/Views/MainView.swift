//
//  mainView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/15/21.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var locationManager = LocationManager()
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("backendUserId") var backendUserId: Int?
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    @AppStorage("backendToken") var backendToken: String = ""
    
    @AppStorage("maxAqi") var maxAqi: Int?
    @AppStorage("latitude") var latitude: Double?
    @AppStorage("longitude") var longitude: Double?
    @AppStorage("locationName") var locationName: String = ""
    
    @AppStorage("currentAqi") var currentAqi: Int?
    
    @EnvironmentObject var currentView: CurrentView
    @EnvironmentObject var aqiDetails: ResponseContainer
    
    private var maxAcceptableAQI: String {
        let aqi = self.maxAqi ?? -1
        if (aqi > -1) {
            return String(aqi)
        }
        else {
            return "Not Set"
        }
    }
    
    private var imageTitle: String {
        if (self.currentAqi ?? 0 >= self.maxAqi ?? 0) {
            return "yeti_sad"
        }
        else {
            return "yeti_happy"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("AQI")
                .font(.largeTitle)
                .padding(EdgeInsets(top: 200, leading: 0, bottom: 15, trailing: 0))
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
                                if (self.backendToken == "" || JwtUtil().isJwtExpired(jwt: self.backendToken)) {
                                    self.currentView.view = "signIn"
                                }
                                
                                if (self.latitude == nil || self.longitude == nil) {
                                    if let location = locationManager.location {
                                        Api().updateUserLocation(userId: self.backendUserId!, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { settings in
                                            self.latitude = settings.latitude
                                            self.longitude = settings.longitude
                                            
                                            Api().reverseGeocode(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0) { place in
                                                let place = place.components(separatedBy: ",")
                                                self.locationName = place.dropFirst().joined(separator: ",").components(separatedBy: " ").prefix(3).joined(separator: " ")
                                            }
                                        }
                                    }
                                }
                            }
                    }
                }
            
            Text(String(self.currentAqi ?? 0))
                .frame(width: 50)
                .font(.largeTitle)
                .padding()
                .border(Color.white, width: 4)
                .onAppear {
                    if (self.backendToken == "" || JwtUtil().isJwtExpired(jwt: self.backendToken)) {
                        self.currentView.view = "signIn"
                    } else {
                        Api().getUserSettings { userSettings in
                            print("got here user settings", userSettings)
                            self.maxAqi = userSettings.maxAqi
                            self.latitude = userSettings.latitude
                            self.longitude = userSettings.longitude
                            
                            Api().getPollution(latitude: self.latitude ?? -1.0, longitude: self.longitude ?? -1.0) { response in
                                self.currentAqi = response.aqi
                                self.aqiDetails.response = response
                            }
                        }
                    }
                }
                .onTapGesture {
                    self.currentView.view = "aqiBreakdown"
                }
            
            Text("Max Acceptable AQI: " + maxAcceptableAQI)
                .padding(.top, 20)
                .padding(.bottom, -10)
            
            ForecastView()
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            Image(imageTitle)
                .resizable()
                .frame(width: 300, height: 300)
                    .padding(.top, -115)
        }
        .padding(.bottom, 160)
    }
}
