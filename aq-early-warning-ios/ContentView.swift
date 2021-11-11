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
    
    private var isSignedIn: Bool {
        !userId.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if userId.isEmpty {
                    SignInButtonView()
                }
                else {
                    //                    signed inw
                }
            }
            .navigationTitle("Sign In")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
