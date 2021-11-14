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
    
    @AppStorage("backendUserId") var backendUserId: Int = -1
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    @AppStorage("token") var token: String = ""
    
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("got here success", auth)
                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:
                    print(credential)
                    
                    // get every time
                    let userId = credential.user
                    
                    // get first time
                    let email = credential.email ?? ""
                    let firstName = credential.fullName?.givenName ?? ""
                    let lastName = credential.fullName?.familyName ?? ""
                    
                    guard let dataToken: Data = credential.identityToken as? Data else { return }
                    guard let token = String(data: dataToken, encoding: String.Encoding.utf8) as? String else { return }
                    self.userId = userId
                    
                    let payload = AuthPaylaod(userId: self.userId, token: token, email: email, firstName: firstName, lastName: lastName)
                    
                    Api().authenticate(payload: payload) { response in
                        if (response.success) {
                            self.token = token
                            self.backendUserId = response.backendUserId
                            self.email = response.email
                            self.firstName = response.firstName
                            self.lastName = response.lastName
                        }
                    }
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
