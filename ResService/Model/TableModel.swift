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
    var color : String
    var x : Float
    var y : Float
}

struct TableInfo {
    var id : Int
    var color : Color
    var location : CGPoint
    
    var tablejson : [String : Any] {
        get {
            return [
                "id" : id,
                "color" : color.description,
                "x" : location.x,
                "y" : location.y
            ]
        }
    }
}
