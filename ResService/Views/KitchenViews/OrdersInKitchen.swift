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
    let paramUniqueOrderNumber = "noorder"

    @Published var P_ordersToDo : [OrderCard] = []
    var localOrdersToDo : [OrderCard] = []
    var uniqueOrderNumber : Int = 0
    
    init() {
        // initalize the connection to the collection, where are some params, which is needed to
        // make a unique value of order (noorder)
        let refparam = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        refparam.observe(DataEventType.value, with: { snaphot in
            guard let paramsinfo = snaphot.value as? [String: Int] else { return }
            if paramsinfo[self.paramUniqueOrderNumber] != nil {
                self.uniqueOrderNumber = paramsinfo[self.paramUniqueOrderNumber]!
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
    
    /**
        The method add current order to Firebase into collection. The collection represts the orderrs in progress. The orders, which are being made.
     
        - Parameter tableNumber: Each table has unique number, which represent a open bill
        - Parameter currentOrder: A dictionary, where its key is a dish name, and its value is number, how many dishes were ordered
     */
    func addOrder(tableNumber: Int, currentOrder : [String : Int]) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(OIKcollectionName)
        let refparams = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        
        // get the unique order number from firebase
        let child = "order\(self.uniqueOrderNumber)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // "2017-01-23T10:12:31.484Z"
        let dateFromString = dateFormatter.date(from: Date.now.formatted(.iso8601))
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let newDate = dateFormatter.string(from: dateFromString!)
        
        // default the time zone is another so we had to add two hours
        let order = [
            "dishes" : "dishes",
            "table" : tableNumber,
            "data" : newDate, // Date.now.formatted()
            "orderNumber" : self.uniqueOrderNumber
        ] as [String : Any]
        ref.child(child).setValue(order)
        
        for (index, order) in currentOrder.enumerated() {
            let o = [
                "dishName" : order.key,
                "dishAmount" : order.value
            ] as [String : Any]
            ref.child(child).child("dishes").child("dish\(index)").setValue(o)
        }
        
        // up-to-date unique order number in firebase
        refparams.child(self.paramUniqueOrderNumber).setValue(self.uniqueOrderNumber + 1)
    }
    
    /**
        An array with up-to-date values are sorted according to the dates
     
     -Returns: A new sorted array in format ```MM/dd/yyyy, hh:mm a```
     */
    func getSorted() -> Void {
        self.P_ordersToDo =  self.P_ordersToDo.sorted(by: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            return dateFormatter.date(from: $0.info.data)! < dateFormatter.date(from: $1.info.data)!
        })
    }
    
    func removeOrderFromList(order: Int) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(OIKcollectionName)
        ref.child("order\(order)").removeValue()
        
        // in case, there is only one order "in progress" and we should check whether this is not last
        if self.P_ordersToDo.count == 1 {
            self.P_ordersToDo = []
        }
    }
}

struct Order : Decodable, Hashable {
    var data : String
    var table : Int
    var orderNumber : Int
}

struct OrderCard : Hashable, Identifiable {
    var id: UUID
    
    static func == (lhs: OrderCard, rhs: OrderCard) -> Bool {
        lhs.info.table < rhs.info.table
    }
    
    let info : Order
    let dishes : [Dish2]
}
