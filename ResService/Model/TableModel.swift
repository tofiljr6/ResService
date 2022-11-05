//
//  TableModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 05/11/2022.
//

import Foundation
import SwiftUI

struct TableInfoDB : Codable {
    var id : Int
    var status : String
    var x : Float
    var y : Float
}

struct TableInfo {
    var id : Int
    var status : Color
    var location : CGPoint
    
    var tablejson : [String : Any] {
        get {
            return [
                "id" : id,
                "status" : status.description,
                "x" : location.x,
                "y" : location.y,
            ]
        }
    }
}
