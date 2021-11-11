//
//  SignInView.swift
//  aq-early-warning
//
//  Created by Ryan Barrett on 11/11/21.
//

import AuthenticationServices
import SwiftUI

struct SignInButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            print("got here sending request")
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            print("got here result", result)
            
            switch result {
            case .success(let auth):
                print("got here success", auth)
                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:
                    print(credential)
                    
                    // get every time
                    let userId = credential.user
                    
                    // get first time
                    let email = credential.email
                    let firstname = credential.fullName?.givenName
                    let lastName = credential.fullName?.familyName
                    
                    self.userId = userId
                    self.email = email ?? ""
                    self.firstName = firstname ?? ""
                    self.lastName = lastName ?? ""
                    break;
                    
                default:
                    break
                }
            case .failure(let error):
                print(error)
            }
        }
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
        .frame(height: 50)
        .padding()
        .cornerRadius(8)
    }
}
