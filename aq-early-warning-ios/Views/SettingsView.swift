//
//  SettingsView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/15/21.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct GreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0.5, blue: 0))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

class NumbersOnly: ObservableObject {
    @Environment(\.colorScheme) var colorScheme
    
    @Published var value = "" {
        didSet {
            let filtered = value.filter {
                return $0.isNumber && Int(value) ?? -1 <= 501 && Int(value) ?? -1 > 0
            }
            
            if value != filtered {
                value = filtered
                self.error = true
            }
            else {
                self.error = false
            }
        }
    }
    @Published var error = false
}

struct SettingsView: View {
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
    @ObservedObject private var locationManager = LocationManager()
    @EnvironmentObject var currentView: CurrentView
    
    @ObservedObject var localMaxAqi = NumbersOnly()
    @State private var showingAlert = false
    @State private var locationa = ""
    
    @State var localLat: Double?
    @State var localLong: Double?
    
    var body: some View {
        HStack {
            Text("Max AQI")
                .font(.title3)
            Spacer()
            
            TextField(String(self.maxAqi ?? 0), text: $localMaxAqi.value, onCommit: {
                if (localMaxAqi.error) {
                    showingAlert = true
                }
                else {
                    Api().updateUserMaxAqi(userId: self.backendUserId ?? 0, maxAqi: Int(localMaxAqi.value) ?? 0) { userSettings in
                        self.maxAqi = userSettings.maxAqi
                    }
                }
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title3)
                .padding()
                .keyboardType(.numbersAndPunctuation)
                .alert(isPresented: $showingAlert) {
                    return Alert(title: Text("Max AQI Value Must Be Between 1 - 500"), dismissButton: .default(Text("Got It")))
                }
        }
        .frame(width: 225)
        .offset(y: -150)
        .onAppear {
            Api().getUserSettings { userSettings in
                print("got here user settings", userSettings)
                self.maxAqi = userSettings.maxAqi
                self.latitude = userSettings.latitude
                self.longitude = userSettings.longitude
            }
        }
        
        Text("Location")
            .frame(width: 300)
            .offset(y: -125)
            .font(.title3)
        
        Text("\(self.latitude ?? 0) \(self.longitude ?? 0)")
            .frame(width: 300)
            .offset(y: -100)
            .font(.title3)
        
        
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .font(.title3)
                        .onTapGesture {
                            print("it worked!")
                            self.currentView.view = "main"
                        }
                        .onAppear {
                            if (self.token == "") {
                                self.currentView.view = "signIn"
                            }
                        }
                }
            }
        
        if let location = locationManager.location {
            Button("Use Current Location") {
                print("\(localLat) \(localLong)")
                Api().updateUserLocation(userId: self.backendUserId!, latitude: localLat!, longitude: localLong!) { settings in
                    self.latitude = settings.latitude
                    self.longitude = settings.longitude
                }
            }
            .frame(height: 44)
            .padding()
            .buttonStyle(GreenButton())
            .offset(y: -75)
            .onAppear {
                localLat = location.coordinate.latitude
                localLong = location.coordinate.longitude
            }
        }
        
    }
}
