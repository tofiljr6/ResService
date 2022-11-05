//
//  ManageTablesViewModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 03/11/2022.
//

import Foundation
import Firebase
import SwiftUI

class DiningRoomViewModel : ObservableObject {
    @Published var tablesInfo : [TableInfo] = []
    private var tablesInfoLocal : [TableInfo] = []
    private var uniqueTableID : Int = 0
    
    enum tableStatus : String {
        case free = "green"
        case reserved = "yellow"
        case occupied = "red"
    }
    
    init() {
        print("ManageTablesViewModel - init")
        let param = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        param.observe(DataEventType.value, with: { snaphot in
            guard let paramsinfo = snaphot.value as? [String: Int] else { return }
            if paramsinfo[tableUniqueID] != nil {
                self.uniqueTableID = paramsinfo[tableUniqueID]!
            }
        })
        
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
            guard let diningRoomTablesInfo = snapshot.value as? [String: Any] else { return }
            for diningtable in diningRoomTablesInfo {
                do {
                    let singleDiningRoomTableInfo =  diningRoomTablesInfo[diningtable.key]! as? [String : Any]
                    let diningRoomTable = try JSONSerialization.data(withJSONObject: singleDiningRoomTableInfo!)
                    let dt = try JSONDecoder().decode(TableInfoDB.self, from: diningRoomTable)
                    
                    self.tablesInfoLocal.append(TableInfo(id: dt.id,
                                                          status: self.getTableStatus(color: dt.status),
                                                          location: CGPoint(x: CGFloat(dt.x), y: CGFloat(dt.y))))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            self.tablesInfo = self.tablesInfoLocal
            self.tablesInfoLocal = []
        })
    }
    
    func getTableStatus(color: String) -> Color {
        let val = tableStatus(rawValue: color)
        
        switch val {
        case .free : return Color.green
        case .reserved : return Color.yellow
        case .occupied : return Color.red
        case .none:
            return Color.brown
        }
    }
    
    func deleteTable(number: Int) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.child("table\(number)").removeValue()
    }
    
    private func setTableStatus(number: Int, color : String) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.child("table\(number)").updateChildValues(["color" : color])
    }
    
    func updateLocationForTableNumber(number : Int, location : CGPoint) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.child("table\(number)").updateChildValues(["x" : location.x, "y": location.y])
    }
    
    func addNewTable() -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        let uid = getUniqueID()
        let newTable = TableInfo(id: uid, status: self.getTableStatus(color: "green"), location: CGPoint(x: 50, y: 50))
        ref.child("table\(uid)").setValue(newTable.tablejson)
    }
    
    private func getUniqueID() -> Int {
        let paramref = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        paramref.child(tableUniqueID).setValue(self.uniqueTableID + 1)
        
        return self.uniqueTableID
    }

}
