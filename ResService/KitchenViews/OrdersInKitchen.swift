//
//  OrderInKitchen.swift
//  ResService
//
//  Created by Mateusz Tofil on 22/10/2022.
//

import Foundation
import Firebase

class OrdersInKitchen : ObservableObject {
    let OIKcollectionName = "ordersInKitchenCollection"
    let paramCollectionName = "param"
    let dbURLConnection = "https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/"

    @Published var P_ordersToDo : [OrderCard] = []
    var localOrdersToDo : [OrderCard] = []
    var uniqueOrderNumber : Int = 0
    
    init() {
        // initalize the connection to the collection, where are some params, which is needed to
        // make a unique value of order (noorder)
        let refparam = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        refparam.observe(DataEventType.value, with: { snaphot in
            guard let paramsinfo = snaphot.value as? [String: Int] else { return }
            if paramsinfo["noorder"] != nil {
                self.uniqueOrderNumber = paramsinfo["noorder"]!
            }
        })
        
        // initialize the connection to the collection wherer are orders in the kitchen,
        // it observes whether new value is appeared
        let ref = Database.database(url: dbURLConnection).reference().child(OIKcollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
            guard let ordersInfo = snapshot.value as? [String : Any] else { return }
            for orderInfo in ordersInfo {
                let json = orderInfo.value as? [String : Any]
                let jsonData = try! JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
                let info = try! JSONDecoder().decode(Order.self, from: jsonData)

                var dishesArray : [Dish2] = []
                let dishes = json!["dishes"]! as? [String : Any] // else { print("wrong type"); return }
    
                if dishes != nil {
                    for dish in dishes! {
                        let jsonDishData = try! JSONSerialization.data(withJSONObject: dish.value)
                        let dishData = try! JSONDecoder().decode(Dish2.self, from: jsonDishData)
                        dishesArray.append(dishData)
                    }
                    // add new UUID() do OrderCard because, when we want to interate it, we have to have
                    // unique key, the information about the table and date does not suffices this, because
                    // two diffrent orders can belong to the same table
                    self.localOrdersToDo.append(OrderCard(id: UUID(), info: info, dishes: dishesArray))
                } else {
                    print("NO DISHES!")
                }
            }
            
            // the pubished array is subsituted by the local array with the same value
            // but the local array is full of up-to-date data from firebase, the items are not
            // sorted, they are uploaded in random queue
            self.P_ordersToDo = self.localOrdersToDo
            self.getSorted()
            self.localOrdersToDo = []
        })
    }
    
    func addOrder(tableNumber: Int, currentOrder : [String : Int]) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(OIKcollectionName)
        let refparams = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        
        // get the unique number from firebase and make it up-to-date
        let child = "order\(self.uniqueOrderNumber)"
        refparams.child("noorder").setValue(self.uniqueOrderNumber + 1)
        
        // default the time zone is another so we had to add two hours
        let order = [
            "dishes" : "dishes",
            "table" : tableNumber,
            "data" : Date.now.addingTimeInterval(2*60*60).formatted()
        ] as [String : Any]
        ref.child(child).setValue(order)
        
        for (index, order) in currentOrder.enumerated() {
            print(index, order)
            let o = [
                "dishName" : order.key,
                "dishAmount" : order.value
            ] as [String : Any]
            ref.child(child).child("dishes").child("dish\(index)").setValue(o)
        }
    }
    
    /**
        An array with up-to-date values are sorted according to the dates
     
     -Returns: A new sorted array in format ```MM/dd/yyyy, hh:mm a```
     */
    func getSorted() -> Void {
        self.P_ordersToDo =  self.P_ordersToDo.sorted(by: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy, hh:mm a"
            return dateFormatter.date(from: $0.info.data)! < dateFormatter.date(from: $1.info.data)!
        })
    }
}

struct Order : Decodable, Hashable {
    var data : String
    var table : Int
}

struct OrderCard : Hashable, Identifiable {
    var id: UUID
    
    static func == (lhs: OrderCard, rhs: OrderCard) -> Bool {
        lhs.info.table < rhs.info.table
    }
    
    let info : Order
    let dishes : [Dish2]
}
