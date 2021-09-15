//
//  ContentView.swift
//  SecondApp
//
//  Created by Cédric Bahirwe on 15/09/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appStore = AppGroupStore(appGroupName: "group.com.cedric.shared")
    
    private var logoutView: some View {
        VStack {
            
            if let user = appStore.userSession {
                Group {
                    Text("Email: \(user.email)")
                    Text("Username: \(user.username)")
                }
                .font(.body.bold())
            }
            Button(action: {
                appStore.removeCurrentSession()
            }) {
                Text("Logout").bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.red)
                    .cornerRadius(4)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var isLoggedIn: Bool  {
        appStore.userSession != nil
    }
    
    @State private var username = ""
    @State private var email = ""
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some View {
        ZStack {
            Color(red: 0.2196078431372549, green: 0.22745098039215686, blue: 0.23921568627450981)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Authentication")
                    .font(.title2.bold())
                    .padding()
                
                if isLoggedIn {
                    
                    logoutView
                    
                } else {
                VStack(alignment: .leading) {
                    Text("Email address")
                        .font(.title3.weight(.semibold))
                    
                    TextField("Enter email", text: $email)
                        .font(.title3)
                        .frame(height: 40)
                        .padding(.leading, 10)
                        .overlay(border)
                }
                
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.title3.weight(.semibold))
                    
                    TextField("username", text: $username)
                        .font(.title3)
                        .frame(height: 40)
                        .padding(.leading, 10)
                        .overlay(border)
                }
                
                Button(action: {
                    let user = AppGroupStore.UserModel(username: username, email: email)
                    appStore.storeSessionLocally(for: user)
                    email = ""
                    username = ""
                    
                }, label: {
                    Text("Login").bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.accentColor)
                        .cornerRadius(4)
                        .foregroundColor(.white)
                })
                }
            }
            
            .padding()
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
        .onChange(of: scenePhase) {
            switch $0 {
            case .active: appStore.refreshSession()
            default: break
            }
        }
        
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius:4)
            .stroke(Color(.lightGray), lineWidth: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
