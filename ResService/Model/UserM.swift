//
//  UserModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/12/2022.
//

import Foundation

struct User : Codable {
    var role : String
    var username : String
    var email : String
    var UUID : String
    var authID : String
}
