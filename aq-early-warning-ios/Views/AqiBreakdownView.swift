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
    @AppStorage("backendToken") var backendToken: String = ""
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var body: some View {
        Text("Components")
            .font(.title2)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            .offset(y: -185)
        
        List {
            Text("Carbon Monoxide: \(self.aqiDetails.response!.aqiComponents?.co ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Nitric Oxide: \(self.aqiDetails.response!.aqiComponents?.no ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Nitrogen Dioxide: \(self.aqiDetails.response!.aqiComponents?.no2 ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Ozone: \(self.aqiDetails.response!.aqiComponents?.o3 ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Sulfur Dioxide: \(self.aqiDetails.response!.aqiComponents?.so2 ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Particulate Matter 2.5: \(self.aqiDetails.response!.aqiComponents?.pm2_5 ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Particulate Matter 10: \(self.aqiDetails.response!.aqiComponents?.pm10 ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Ammonia: \(self.aqiDetails.response!.aqiComponents?.nh3 ?? 0)")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(minHeight: minRowHeight * 8)
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
                        if (self.backendToken == "" || JwtUtil().isJwtExpired(jwt: self.backendToken)) {
                            self.currentView.view = "signIn"
                        }
                    }
            }
        }
    }
}
