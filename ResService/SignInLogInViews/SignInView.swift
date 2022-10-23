//
//  SignInView.swift
//  ResService
//
//  Created by Mateusz Tofil on 23/10/2022.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var userIsLoggedIn : Bool = false
    
    var body: some View {
        if userIsLoggedIn {
            ContentView()
        } else {
            content
        }
    }
    
    var testview : some View {
        Text("zalogowany!")
    }
    
    var content : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(155))
                .offset(y: -400)
            
            VStack(spacing: 30) {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 50, weight: .bold, design: .monospaced))
                    .offset(x: -50, y: -150)
                
                TextField("Email", text: $email)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.blue)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                
                Button {
                    register()
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .foregroundStyle(.linearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        ).foregroundColor(.white)
                }.padding(.top)
                    .offset(y: 100)
                
                
                Button {
                    // login
                    login()
                } label: {
                    Text("Already have an account? Login")
                        .bold()
                        
                }.padding(.top)
                    .offset(y: 100)
            }.frame(width: 350)
//                .onAppear {
//                    Auth.auth().addStateDidChangeListener { auth, user in
//                        if user != nil {
//                            userIsLoggedIn.toggle()
//                            print("zmiana!")
//                        }
//                    }
//                }
        }.ignoresSafeArea()
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            userIsLoggedIn.toggle()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
