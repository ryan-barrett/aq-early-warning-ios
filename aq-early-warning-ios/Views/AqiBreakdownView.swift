//
//  AqiBreakdownView.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/16/21.
//

import SwiftUI

struct AqiBreakdownView: View {
    @EnvironmentObject var aqiDetails: ResponseContainer
    
    @EnvironmentObject var currentView: CurrentView
    @AppStorage("token") var token: String = ""
    
    var body: some View {
        Text("Components")
            .font(.title2)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            .offset(y: -185)
        
        VStack {
            Text("co: \(self.aqiDetails.response!.aqiComponents?.co ?? 0)")
            Text("no: \(self.aqiDetails.response!.aqiComponents?.no ?? 0)")
            Text("no2: \(self.aqiDetails.response!.aqiComponents?.no2 ?? 0)")
            Text("o3: \(self.aqiDetails.response!.aqiComponents?.o3 ?? 0)")
            Text("so2: \(self.aqiDetails.response!.aqiComponents?.so2 ?? 0)")
            Text("pm2_5: \(self.aqiDetails.response!.aqiComponents?.pm2_5 ?? 0)")
            Text("pm10: \(self.aqiDetails.response!.aqiComponents?.pm10 ?? 0)")
            Text("nh3: \(self.aqiDetails.response!.aqiComponents?.nh3 ?? 0)")
        }
        .offset(y: -165)
        .navigationBarTitle(Text("AQI Breakdown"), displayMode: .inline)
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
    }
}
