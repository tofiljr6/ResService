//
//  OrderModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import Foundation

struct Order : Decodable, Hashable {
    var data : String
    var table : Int
    var orderNumber : Int
}
