//
//  SignInView.swift
//  aq-early-warning
//
//  Created by Ryan Barrett on 11/11/21.
//

import AuthenticationServices
import SwiftUI

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("backendUserId") var backendUserId: Int?
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    @AppStorage("token") var token: String = ""
    @AppStorage("backendToken") var backendToken: String = ""
    
    @AppStorage("maxAqi") var maxAqi: Int?
    @AppStorage("latitude") var latitude: Double?
    @AppStorage("longitude") var longitude: Double?
    
    @AppStorage("currentAqi") var currentAqi: Int?
    @EnvironmentObject var currentView: CurrentView
    
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
                    self.token = token
                    
                    let payload = AuthPaylaod(userId: self.userId, email: self.email, firstName: self.firstName, lastName: self.lastName, token: "Bearer \(self.token)")
                    
                    Api().authenticate(payload: payload) { response in
                        print("got here!!!", response)
                        self.backendUserId = response.iosResponse.backendUserId
                        self.email = response.iosResponse.email
                        self.firstName = response.iosResponse.firstName
                        self.lastName = response.iosResponse.lastName
                        self.backendToken = response.jwt
                        
                        Api().getUserSettings { userSettings in
                            print(userSettings)
                            self.maxAqi = userSettings.maxAqi
                            self.latitude = userSettings.latitude
                            self.longitude = userSettings.longitude
                            self.currentView.view = "main"
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
        .navigationBarTitle(Text("AQ Early Warning"), displayMode: .inline)
        .frame(height: 50)
        .padding()
        .cornerRadius(8)
    }
}
