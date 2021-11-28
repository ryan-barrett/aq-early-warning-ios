//
//  ContentView.swift
//  aq-early-warning
//
//  Created by Ryan Barrett on 11/11/21.
//

import SwiftUI

class CurrentView: ObservableObject {
    @Published var view = "main"
}

class ForecastDetailTitle: ObservableObject {
    @Published var day = ""
}

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
    
    @StateObject var currentView = CurrentView()
    @StateObject var aqiDetails: ResponseContainer = ResponseContainer(response: PollutionResponse(latitude: nil, longitude: nil, aqi: nil, aqiComponents: nil, date: nil))
    @StateObject var forecastContainer: ForecastContainer = ForecastContainer(forecast: [])
    @StateObject var forecastDetailTitle = ForecastDetailTitle()
    
    var body: some View {
        NavigationView {
            VStack {
                switch currentView.view {
                case "signIn":
                    SignInView()
                case "main":
                    MainView()
                case "settings":
                    SettingsView()
                case "aqiBreakdown":
                    AqiBreakdownView()
                case "forecastDetail":
                    ForecastDetailView()
                default:
                    SignInView()
                }
            }
        }
        .environmentObject(currentView)
        .environmentObject(aqiDetails)
        .environmentObject(forecastContainer)
        .environmentObject(forecastDetailTitle)
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            AppDelegate.orientationLock = .all
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
