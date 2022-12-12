//
//  RegisterView.swift
//  ResService
//
//  Created by Mateusz Tofil on 11/11/2022.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var name : String = ""
    @Binding var createUserTabIsShowing : Bool
    
    var body: some View {
        ZStack {
            // background
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(155))
                .offset(y: -350)
            
            VStack(spacing: 20) {
                Text("Register")
                    .foregroundColor(.white)
                    .font(.system(size: 50, weight: .bold, design: .monospaced))
                    .offset(x: -50, y: -150)
                
                VStack(spacing: 20) {
                    Group {
                        TextField("Name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.blue)
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.blue)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                        
                        
                        Button {
                            register()
                            createUserTabIsShowing = false
                        } label: {
                            Text("Create an account")
                                .bold()
                                .frame(width: 200, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .foregroundStyle(.linearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                ).foregroundColor(.white)
                        }.padding(.top)
                    }.offset(y: 70)
                }.frame(width: 350)
            }
        }
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
                "role" : "client",
                "UUID" : UUID().uuidString,
                "email" : email,
                "authID" : userID
            ]
            ref.child("users").child(userID).setValue(userinfo)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Text(" ").sheet(isPresented: .constant(true)) {
            RegisterView(createUserTabIsShowing: .constant(true))
        }
    }
}
