//
//  Forecast.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/17/21.
//

import SwiftUI

class ForecastContainer: ObservableObject {
    var forecast: [DailyForecastBrief]
    
    init(forecast: [DailyForecastBrief]) {
        self.forecast = forecast
    }
}

struct DailyForecastBrief: Identifiable {
    let low: Int
    let high: Int
    var day: String
    let id: Int
    var entries: [PollutionForecastEntry]
}

class ForecastUtil {
    func formatForecast(entries: [PollutionForecastEntry]) -> [DailyForecastBrief] {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        
        var map = [String : DailyForecastBrief]()
        
        for entry in entries {
            let day = formatter.string(from: Date(timeIntervalSince1970: Double(entry.dt!))).components(separatedBy: ", ").prefix(1).joined(separator: "")
            
            if map[day] == nil {
                map[day] = DailyForecastBrief(low: entry.aqi!, high: entry.aqi!, day: day, id: entry.dt!, entries: [entry])
            }
            else {
                map[day] = DailyForecastBrief(low: min(entry.aqi!, map[day]!.low), high: max(entry.aqi!, map[day]!.high), day: day, id: entry.dt!, entries: map[day]!.entries + [entry])
            }
        }
        var forecast = map.map {$0.value}.sorted(by: { $0.id < $1.id })
        forecast[0].day = "Today"
        forecast[1].day = "Tomorrow"
        return forecast
    }
    
    func convertDateToString(dt: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: Date(timeIntervalSince1970: Double(dt)))
    }
}
