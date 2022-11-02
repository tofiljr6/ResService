//
//  MenuSectionAndItem.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import Foundation

struct MenuSection : Codable, Identifiable {
    var id : UUID
    var name : String
    var items : [MenuItem]
}

struct MenuItem : Codable, Identifiable {
    var id : UUID
    var name: String
}
