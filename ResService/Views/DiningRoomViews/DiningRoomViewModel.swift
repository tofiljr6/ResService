//
//  ManageTablesViewModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 03/11/2022.
//

import Foundation
import Firebase

class DiningRoomViewModel : ObservableObject {
    @Published var tablesInfo : [TableInfo] = []
    private var tablesInfoLocal : [TableInfo] = []
    
    init() {
        print("ManageTablesViewModel - init")
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
            guard let diningRoomTablesInfo = snapshot.value as? [String: Any] else { return }
            for diningtable in diningRoomTablesInfo {
                do {
                    let singleDiningRoomTableInfo =  diningRoomTablesInfo[diningtable.key]! as? [String : Any]
                    let diningRoomTable = try JSONSerialization.data(withJSONObject: singleDiningRoomTableInfo!)
                    let dt = try JSONDecoder().decode(TableInfoDB.self, from: diningRoomTable)
                    
                    self.tablesInfoLocal.append(TableInfo(id: dt.id,
                                                     color: .brown, // TODO: enum and switch
                                                     location: CGPoint(x: CGFloat(dt.x), y: CGFloat(dt.y))))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            self.tablesInfo = self.tablesInfoLocal
            self.tablesInfoLocal = []
        })
    }
    
    func updateLocationForTableNumber(number : Int, location : CGPoint) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        ref.child("table\(number)").updateChildValues(["x" : location.x, "y": location.y])
    }
    
    func addNewTable() -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(diningRoomCollectionName)
        let newTable = TableInfo(id: tablesInfo.count + 1, color: .brown, location: CGPoint(x: 50, y: 50))
        ref.child("table\(tablesInfo.count + 1)").setValue(newTable.tablejson)
    }
}
