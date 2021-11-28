//
//  ForecastDetail.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/22/21.
//

import SwiftUI

struct ForecastHour: Identifiable {
    let id = UUID()
    let time: String
    let aqi: Int
}

struct ForecastHourRow: View {
    var row: ForecastHour
    var maxAqi: Int

    var body: some View {
        Text("\(row.time) - \(row.aqi) AQI")
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(self.maxAqi < row.aqi ? .red : .green)
    }
}

struct ForecastDetailView: View {
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
    
    @State var forecastRows: [ForecastHour] = []
    
    var body: some View {
        List(self.forecastRows) { row in
            ForecastHourRow(row: row, maxAqi: self.maxAqi ?? 3)
        }
        .navigationBarTitle(Text("Forecast Details: " + self.forecastDetailTitle.day), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .font(.title3)
                    .onTapGesture {
                        self.currentView.view = "main"
                    }
                    .onAppear {
                        if (self.backendToken == "" || JwtUtil().isJwtExpired(jwt: self.backendToken)) {
                            self.currentView.view = "signIn"
                        }
                        var relevantEntries: [PollutionForecastEntry] = []
                        let forecast = self.forecastContainer.forecast
                        
                        for forecastedDay in forecast {
                            if (self.forecastDetailTitle.day == forecastedDay.day) {
                                relevantEntries = relevantEntries + forecastedDay.entries
                                break
                            }
                        }
                        
                        for entry in relevantEntries {
                            self.forecastRows.append(ForecastHour(time: ForecastUtil().convertDateToString(dt: entry.dt!), aqi: entry.aqi!))
                        }
                    }
            }
        }
    }
}
