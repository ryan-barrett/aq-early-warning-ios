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
    
    private var isSignedIn: Bool {
        !userId.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.token == "") {
                    SignInView()
                }
                else {
                    Text(self.email)
                    Text(self.firstName)
                    Text(self.lastName)
                    Text(self.userId)
                    SignInView()
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
