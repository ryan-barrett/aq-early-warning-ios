//
//  ForecastView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/17/21.
//

import SwiftUI

struct ForecastDay: Identifiable {
    let id = UUID()
    let day: String
    let low: Int
    let high: Int
}

struct ForecastDayRow: View {
    var row: ForecastDay

    var body: some View {
        Text("\(row.day):  Low - \(row.low)   High - \(row.high)")
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ForecastView: View {
    @AppStorage("maxAqi") var maxAqi: Int?
    @AppStorage("latitude") var latitude: Double?
    @AppStorage("longitude") var longitude: Double?
    @AppStorage("backendToken") var backendToken: String = ""
    
    @AppStorage("today") var today: String = ""
    @AppStorage("tomorrow") var tomorrow: String = ""
    @AppStorage("twoDay") var twoDay: String = ""
    @AppStorage("threeDay") var threeDay: String = ""
    @AppStorage("fourDay") var fourDay: String = ""
    
    @EnvironmentObject var currentView: CurrentView
    @EnvironmentObject var forecastContainer: ForecastContainer
    @EnvironmentObject var forecastDetailTitle: ForecastDetailTitle
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    @State var forecast: [DailyForecastBrief] = []
    
    var body: some View {
        Text("Forecast")
            .font(.title2)
            .padding(EdgeInsets(top: 35, leading: 0, bottom: -15, trailing: 0))
            .onAppear {
                if (self.backendToken == "" || JwtUtil().isJwtExpired(jwt: self.backendToken)) {
                    self.currentView.view = "signIn"
                }
                else {
                    Api().getPollutionForecast(latitude: self.latitude ?? -1.0, longitude: self.longitude ?? -1.0) { forecast in
                        self.forecastContainer.forecast = ForecastUtil().formatForecast(entries: forecast.list)
                        self.forecast = self.forecastContainer.forecast
                        
                        
                        // TODO: this is fragile, it needs to be redone properly
                        self.today = self.forecast.count > 0 ? "\(self.forecast[0].day):  Low - \(self.forecast[0].low)   High - \(self.forecast[0].high)" : "-"
                        self.tomorrow = self.forecast.count > 1 ? "\(self.forecast[1].day):  Low - \(self.forecast[1].low)   High - \(self.forecast[1].high)" : "-"
                        self.twoDay = self.forecast.count > 2 ? "\(self.forecast[2].day):  Low - \(self.forecast[2].low)   High - \(self.forecast[2].high)" : "-"
                        self.threeDay = self.forecast.count > 3 ? "\(self.forecast[3].day):  Low - \(self.forecast[3].low)   High - \(self.forecast[3].high)" : "-"
                        self.fourDay = self.forecast.count > 4 ? "\(self.forecast[4].day):  Low - \(self.forecast[4].low)   High - \(self.forecast[4].high)" : "-"
                    }
                }
            }
        
//        List(self.forecast) { row in
//            ForecastDayRow(row: ForecastDay(day: row.day, low: row.low, high: row.high))
//        }
//        .frame(maxWidth: .infinity, alignment: .center)
        
        List {
            Text(self.today)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    self.forecastDetailTitle.day = self.today.components(separatedBy: ":").prefix(1).joined(separator: "")
                    self.currentView.view = "forecastDetail"
                }
            Text(self.tomorrow)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    self.forecastDetailTitle.day = self.tomorrow.components(separatedBy: ":").prefix(1).joined(separator: "")
                    self.currentView.view = "forecastDetail"
                }
            Text(self.twoDay)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    self.forecastDetailTitle.day = self.twoDay.components(separatedBy: ":").prefix(1).joined(separator: "")
                    self.currentView.view = "forecastDetail"
                }
            Text(self.threeDay)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    self.forecastDetailTitle.day = self.threeDay.components(separatedBy: ":").prefix(1).joined(separator: "")
                    self.currentView.view = "forecastDetail"
                }
            Text(self.fourDay)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    self.forecastDetailTitle.day = self.fourDay.components(separatedBy: ":").prefix(1).joined(separator: "")
                    self.currentView.view = "forecastDetail"
                }
        }
        .frame(minHeight: minRowHeight * 8)
    }
}
