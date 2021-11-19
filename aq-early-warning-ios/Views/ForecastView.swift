//
//  ForecastView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/17/21.
//

import SwiftUI

struct ForecastView: View {
    @AppStorage("maxAqi") var maxAqi: Int?
    @AppStorage("latitude") var latitude: Double?
    @AppStorage("longitude") var longitude: Double?
    @AppStorage("token") var token: String = ""
    
    @AppStorage("today") var today: String = ""
    @AppStorage("tomorrow") var tomorrow: String = ""
    @AppStorage("twoDay") var twoDay: String = ""
    @AppStorage("threeDay") var threeDay: String = ""
    @AppStorage("fourDay") var fourDay: String = ""
    
    @EnvironmentObject var currentView: CurrentView
    
    @State var forecast: [dailyForecastBrief] = []
    
    var body: some View {
        Text("Forecast")
            .font(.title2)
            .padding(EdgeInsets(top: 35, leading: 0, bottom: 10, trailing: 0))
            .onAppear {
                if (self.token == "") {
                    self.currentView.view = "signIn"
                }
                else {
                    Api().getPollutionForecast(latitude: self.latitude ?? -1.0, longitude: self.longitude ?? -1.0) { forecast in
                        self.forecast = ForecastUtil().getAqiLowAndHigh(entries: forecast.list)
                        
                        // TODO: this is fragile, it needs to be redone properly
                        self.today = "\(self.forecast[0].day): Low - \(self.forecast[0].low) High - \(self.forecast[0].high)"
                        self.tomorrow = "\(self.forecast[1].day): Low - \(self.forecast[1].low) High - \(self.forecast[1].high)"
                        self.twoDay = "\(self.forecast[2].day): Low - \(self.forecast[2].low) High - \(self.forecast[2].high)"
                        self.threeDay = "\(self.forecast[3].day): Low - \(self.forecast[3].low) High - \(self.forecast[3].high)"
                        self.fourDay = "\(self.forecast[4].day): Low - \(self.forecast[4].low) High - \(self.forecast[4].high)"
                    }
                }
            }
        
        Text(self.today)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        Text(self.tomorrow)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        Text(self.twoDay)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        Text(self.threeDay)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        Text(self.fourDay)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
    }
}
