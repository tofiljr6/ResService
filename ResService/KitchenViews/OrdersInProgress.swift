//
//  OrdersInProgress.swift
//  ResService
//
//  Created by Mateusz Tofil on 17/10/2022.
//
//  MVC - model view controller

import Foundation
import Firebase


class OrdersInProgress : ObservableObject {
    let ordersCollectionName = "ordersCollection"
    let dbURLConnection = "https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/"

    @Published var tabledishesDict : [String: [Dish2]] = [:]
    var singleTableOrders : [Dish2] = []
    var currentOrder : [String : Int] = [:]
    
    private let decoder = JSONDecoder()
    
    init() {
        #if PREVIEW
        self.tabledishesDict["table1"] =  [Dish2(dishName: "Curry", dishAmount: 3)]
        self.progress.getDishesToTisch(number: 1) = [Dish2(dishName: "Curry", dishAmount: 3)]
        #else
        print("listening")
        let ref = Database.database(url: dbURLConnection).reference().child(ordersCollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
            guard let tablesInfo = snapshot.value as? [String: Any] else { return}
            for table in tablesInfo {
                do {
                    let singleTableInfo = tablesInfo[table.key]! as? [String: Any]
//                    print(table.key)
                    for j in singleTableInfo! {
                        if j.key == "dishes" {
                            let dishes = singleTableInfo![j.key]! as? [String: Any]
                            for dish in dishes! {
                                let jsonDishData = dishes![dish.key]! as? [String: Any]
                                let dishData =  try JSONSerialization.data(withJSONObject: jsonDishData!)
                                let dish = try JSONDecoder().decode(Dish2.self, from: dishData)
                                
                                self.singleTableOrders.append(dish)
                            }
                        }
                    }
                    self.tabledishesDict[table.key] = self.singleTableOrders
//                    print(self.tabledishesDict)
                    self.singleTableOrders.removeAll()
                } catch let error {
                    print(error)
                }
            }
        })
        #endif
    }
    
    func getDishesToTisch(number: Int) -> [Dish2] {
        return self.tabledishesDict["table\(number)"]!
    }
    
    /**
        Add new dishes to order
        
     - Parameter number: The number of the table to which, the waiter wants to add the order
     */
    func addDishesToTisch(number: Int) -> Void {
        // number -> number stolika do którego będziemy przypisuwać
        
        let ref = Database.database(url: dbURLConnection).reference().child(ordersCollectionName)
        
        var tmp : [String: Int] = [:]
        
        // old -> tabledischesDict
        let ds : [Dish2] = self.tabledishesDict["table\(number)"] ?? [] // in case, the table's orders are empty, it is nothing to fetch from firebase
        for d in ds {
            tmp[d.dishName] = d.dishAmount
        }
        
        // new -> currentOrder
        for c in currentOrder {
            if tmp[c.key] != nil {
                tmp[c.key]! += c.value
            } else {
                tmp[c.key] = c.value
            }
        }
        
//        print(tmp)
        
        var counter = 0
        for t in tmp {
            let d = [
                "dishName" : t.key,
                "dishAmount" : t.value
            ] as [String: Any]
            ref.child("table\(number)").child("dishes").child("dish\(counter)").setValue(d)
            counter += 1
        }
        self.currentOrder.removeAll()
    }
    
    // TODO: lazy? read about this !!!
////    private lazy var databasePath: DatabaseReference? = {
////        let ref = Database.database().reference().child("ordersCollection")
////        return ref
////    }()
}

struct Dish2 : Codable, Hashable {
    let dishName : String
    let dishAmount : Int
}
