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

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter {
                return $0.isNumber && Int(value) ?? -1 <= 5 && Int(value) ?? -1 > 0
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
    
    var body: some View {
        HStack {
            Text("Max AQI")
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
                .padding()
                .alert(isPresented: $showingAlert) {
                    return Alert(title: Text("Max AQI Value Must Be Between 1 - 5"), dismissButton: .default(Text("Got It")))
                }
        }
        .frame(width: 225)
        .offset(y: -175)
        
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
            Text("Your location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
}
