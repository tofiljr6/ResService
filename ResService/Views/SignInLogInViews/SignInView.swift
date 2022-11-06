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
    @State private var name : String = ""
    @State private var userIsLoggedIn : Bool = false
    
    var body: some View {
        if userIsLoggedIn {
            ContentView()
        } else {
             content
//            ManageTablesView()
        }
    }
    
    var content : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(155))
                .offset(y: -350)
            
            VStack(spacing: 20) {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 50, weight: .bold, design: .monospaced))
                    .offset(x: -50, y: -150)
                Group {
                    TextField("Name", text: $name)
                        .textFieldStyle(.plain)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.blue)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.plain)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.blue)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                }.offset(y: 70)
                
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
            Group {
                    Button("boss") {
                        email = "boss@gmail.com"
                        password = "123456"
                        login()
                    }.offset(x: -50, y: -60)
//                    Button("waiter") {
//                        email = "tester@gmail.com"
//                        password = "123456"
//                        login()
//                    }.offset(x: 50, y: -60)
                    Button("consumer") {
                        email = "user1@gmail.com"
                        password = "123456"
                        login()
                    }.offset(x: 50, y: -60)
            }
            
        }.ignoresSafeArea()
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            // add additinal information about user to firebase collection
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database(url: dbURLConnection ).reference()
            
            let userinfo = [
                "username" : name,
                "role" : "client"
            ]
            ref.child("users").child(userID).setValue(userinfo)
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
