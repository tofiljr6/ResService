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
    @State private var createUserTabIsShowing : Bool = false
    @State private var isUserEmailExistInDB : Bool = true

    var body: some View {
        if UserDefaults.standard.object(forKey: "userUIDey") != nil {
            ContentView()
        } else {
            if userIsLoggedIn {
                ContentView()
            } else {
                content
            }
        }
    }
    
    var content : some View {
        ZStack {
            // background
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
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.blue)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                }.offset(y: 70)
                
                Button {
                    login()
                } label: {
                    Text("Log in")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .foregroundStyle(.linearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        ).foregroundColor(.white)
                }.padding(.top)
                    .offset(y: 50)
                
                
                Button {
                    createUserTabIsShowing.toggle()
                } label: {
                    Text("Are you new? Create an account")
                        .bold()
                }.padding(.top)
                .offset(y: 80)
            }.frame(width: 350)
                .sheet(isPresented: $createUserTabIsShowing) {
                    RegisterView(createUserTabIsShowing : $createUserTabIsShowing)
                }
            
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
//                        userModel.login(email: email, password: password)
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
//                        userModel.login(email: email, password: password)
                        login()
//                        UserDefaults.standard.removeObject(forKey: "userUIDey")
//                        UserDefaults.standard.synchronize()
                    }.offset(x: 50, y: -60)
            }
            
            Group {
                if !isUserEmailExistInDB {
                    Text("Email or password is incorrect")
                        .foregroundColor(.red)
                        .font(.callout)
                        .offset(y: 125)
                }
            }
            
        }.ignoresSafeArea()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                isUserEmailExistInDB = false
            }

            
            
            let uid = Auth.auth().currentUser?.uid

            if uid != nil {
                print(uid!.description)
                userIsLoggedIn.toggle()
                UserDefaults.standard.set(uid!, forKey: "userUIDey")
                UserDefaults.standard.synchronize()
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
