//
//  NotificationViewModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/12/2022.
//

import Foundation
import Firebase

struct NotificationOrder : Codable {
    var orderNumber : Int
    var tableName : String
}

final class NotificationViewModel : ObservableObject {
    @Published var notificationArray : [NotificationOrder] = []
    private var notificationArrayLocal : [NotificationOrder] = []
    
    init() {
        print("NotificationViewModel - connect")
        
        let ref = Database.database(url: dbURLConnection).reference().child(notificationCollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
            guard let notificationInfo = snapshot.value as? [String : Any] else { return }
            for notifiInfo in notificationInfo {
                let json = notifiInfo.value as? [String : Any]
                let jsonData = try! JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
                let info = try! JSONDecoder().decode(NotificationOrder.self, from: jsonData)

                
                self.notificationArrayLocal.append(info)
            }
            self.notificationArray = self.notificationArrayLocal.sorted(by: {n1, n2 in
                n1.orderNumber < n2.orderNumber
            })
            self.notificationArrayLocal = []
        })
    }
    
    func add(orderNumber: Int, tableName : String) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(notificationCollectionName)
        let notificationInfo = [
            "orderNumber" : orderNumber,
            "tableName" : tableName
        ] as [String : Any]
        
        ref.child("order\(orderNumber)").setValue(notificationInfo)
    }
    
    func remove(at offset : IndexSet) {
        let ids = offset.map({self.notificationArray[$0].orderNumber})
        
        let ref = Database.database(url: dbURLConnection).reference().child(notificationCollectionName)
        ref.child("order\(ids[0].description)").removeValue()
        
        self.notificationArray.remove(atOffsets: offset)
    }
}
