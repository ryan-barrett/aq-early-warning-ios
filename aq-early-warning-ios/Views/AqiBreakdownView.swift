//
//  AqiBreakdownView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/16/21.
//

import SwiftUI

struct AqiBreakdownView: View {
    @ObservedObject var aqiDetails: PollutionResponse
    
    var body: some View {
        Text("Air Breakdown")
            .font(.title2)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))

        Text("co: \(self.aqiDetails.aqiComponents?.co ?? 0)")
        Text("no: \(self.aqiDetails.aqiComponents?.no ?? 0)")
        Text("no2: \(self.aqiDetails.aqiComponents?.no2 ?? 0)")
        Text("o3: \(self.aqiDetails.aqiComponents?.o3 ?? 0)")
        Text("so2: \(self.aqiDetails.aqiComponents?.so2 ?? 0)")
        Text("pm2_5: \(self.aqiDetails.aqiComponents?.pm2_5 ?? 0)")
        Text("pm10: \(self.aqiDetails.aqiComponents?.pm10 ?? 0)")
        Text("nh3: \(self.aqiDetails.aqiComponents?.nh3 ?? 0)")
    }
}
