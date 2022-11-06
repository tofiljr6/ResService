//
//  MenuModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 27/10/2022.
//

import Foundation

struct Menu : Codable {
    var dishID : Int
    var dishDescription : String
    var dishName : String
    var dishPrice : Double
    var dishProducts : String
    var dishOrderInMenu : Int
    var dishCategory : String
}
