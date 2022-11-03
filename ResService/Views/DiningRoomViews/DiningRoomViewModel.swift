//
//  ManageTablesViewModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 03/11/2022.
//

import Foundation
import SwiftUI

class DiningRoomViewModel : ObservableObject {
    @Published var tablesInfo : [TableInfo] = []
    
    init() {
        print("ManageTablesViewModel - init")
        tablesInfo.append(TableInfo(id: 1, color: .green, location: CGPoint(x: 50, y: 50)))
        tablesInfo.append(TableInfo(id: 2, color: .blue, location: CGPoint(x: 140, y: 120)))
    }
    
    func updateLocationForTableNumber(number : Int, location : CGPoint) -> Void {
        tablesInfo[number - 1].location = location
    }
    
    func addNewTable() -> Void {
        tablesInfo.append(TableInfo(id: tablesInfo.count + 1, color: .brown, location: CGPoint(x: 50, y: 50)))
    }
}


struct TableInfo {
    var id : Int
    var color : Color
    var location : CGPoint
}
