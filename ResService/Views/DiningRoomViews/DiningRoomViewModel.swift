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
                                                          status: self.getTableStatus(forColor: dt.status),
                                                          location: CGPoint(x: CGFloat(dt.x), y: CGFloat(dt.y))))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            self.tablesInfo = self.tablesInfoLocal
            self.tablesInfoLocal = []
        })
    }
    
    /**
        The function returns a color from string. The color means status of table, for example free or ocuppied
     
     - Note: Deflaut color for not defined colors is brown
     
     - Parameter color : the string name of status.
     
     - Return : Return an accurate color in according to SwiftUI Colors
     */
    func getTableStatus(forColor status: String) -> Color {
        let val = tableStatus(rawValue: status)
        
        switch val {
        case .free : return Color.green
        case .reserved : return Color.yellow
        case .occupied : return Color.red
        case .none:
            return Color.brown
        }
    }
    
    /**
        A function deletes from database a table
    
     - Parameter number : The number of the table which we want to delete.
     */
    func deleteTable(number: Int) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.child("table\(number)").removeValue()
    }
    
    /**
        A function sets a new status for the table. The new status is saved in database.
    
     - Parameter number : The number of the table which we want to change status.
     
     - Parameter color : A new name of color.
     */
    private func setTableStatus(number: Int, color : String) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.child("table\(number)").updateChildValues(["color" : color])
    }
    
    /**
        A function sets a new location of the table. The new location is saved in database.
    
     - Parameter number : The number of the table which we want to change status.
     
     - Parameter location : A new coordinates of table.
     */
    func updateLocationForTableNumber(number : Int, location : CGPoint) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.child("table\(number)").updateChildValues(["x" : location.x, "y": location.y])
    }
    
    /**
        A function adds a new table to the dining room.
     
     - Note : The status of the new added table is always setted as "free"
     */
    func addNewTable() -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        let uid = getUniqueID()
        let newTable = TableInfo(id: uid, status: self.getTableStatus(forColor: "green"), location: CGPoint(x: 50, y: 50))
        ref.child("table\(uid)").setValue(newTable.tablejson)
    }
    
    /**
        A function gets a unique table ID
     
     - Return : The unique table ID
     */
    private func getUniqueID() -> Int {
        let paramref = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        paramref.child(tableUniqueID).setValue(self.uniqueTableID + 1)
        
        return self.uniqueTableID
    }

}
