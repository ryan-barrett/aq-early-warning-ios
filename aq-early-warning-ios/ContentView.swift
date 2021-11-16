//
//  ContentView.swift
//  aq-early-warning
//
//  Created by Ryan Barrett on 11/11/21.
//

import SwiftUI

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
    
//    private var isSignedIn: Bool {
//        !userId.isEmpty
//    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.token == "") {
                    SignInView()
                }
                else {
                    MainView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
