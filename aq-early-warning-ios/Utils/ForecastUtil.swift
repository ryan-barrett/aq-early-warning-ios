//
//  Forecast.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/17/21.
//

import SwiftUI

struct dailyForecastBrief: Identifiable {
    let low: Int
    let high: Int
    var day: String
    let id: Int
}

class ForecastUtil {
    func getAqiLowAndHigh(entries: [PollutionForecastEntry]) -> [dailyForecastBrief] {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        
        var map = [String : dailyForecastBrief]()
        
        for entry in entries {
            let day = formatter.string(from: Date(timeIntervalSince1970: Double(entry.dt!))).components(separatedBy: ", ").prefix(2).joined(separator: " ")
            
            if map[day] == nil {
                map[day] = dailyForecastBrief(low: entry.aqi!, high: entry.aqi!, day: day, id: entry.dt!)
            }
            else {
                map[day] = dailyForecastBrief(low: min(entry.aqi!, map[day]!.low), high: max(entry.aqi!, map[day]!.high), day: day, id: entry.dt!)
            }
        }
        var forecast = map.map {$0.value}.sorted(by: { $0.id < $1.id })
        forecast[0].day = "Today"
        forecast[1].day = "Tomorrow"
        return forecast
    }
}
