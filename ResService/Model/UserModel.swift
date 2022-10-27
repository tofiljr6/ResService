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
    
    init() {
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
}
