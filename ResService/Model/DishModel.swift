//
//  DishModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import Foundation

struct Dish : Codable, Hashable {
    let dishName : String
    let dishAmount : Int
}
