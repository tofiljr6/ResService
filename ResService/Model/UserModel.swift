//
//  UserModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 23/10/2022.
//

import Foundation
import Firebase


class UserModel : ObservableObject {
    let usersCollection = "users"
    let dbURLConnection = "https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/"
    private let usernameCellname = "username"
    private let roleCellname = "role"
    
    @Published var username : String = ""
    @Published var role : String = ""
    @Published var userIsLoggedIn : Bool = false
    
    func initUser() {
        let ref = Database.database(url: dbURLConnection).reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }

        ref.child("users/\(userID)").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if snapshot != nil {
                let userinfo = snapshot!.value as? [String : String] ?? [:];
                print(userinfo[self.usernameCellname]!)
                self.username = userinfo[self.usernameCellname] ?? "Unknown"
                self.role = userinfo[self.roleCellname] ?? Role.unknown.rawValue
            }
        });
    }
    
    func register(email : String, password : String, userName : String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            // add additinal information about user to firebase collection
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database(url: self.dbURLConnection ).reference()
            
            let userinfo = [
                "username" : userName,
                "role" : "client"
            ]
            ref.child("users").child(userID).setValue(userinfo)
        }
    }
    
    func login(email : String, password : String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            self.userIsLoggedIn.toggle()
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userIsLoggedIn.toggle()
            UserDefaults.standard.removeObject(forKey: "userUIDey")
            UserDefaults.standard.synchronize()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
