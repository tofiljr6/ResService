//
//  OrdersInProgress.swift
//  ResService
//
//  Created by Mateusz Tofil on 17/10/2022.
//
//  MVC - model view controller

import Foundation
import Firebase


class OrdersInProgressViewModel : ObservableObject {
    @Published var tabledishesDict : [String: [Dish]] = [:]
    @Published var currentOrder : [String : Int] = [:]
    
    var singleTableOrders : [Dish] = []
    
    
    private let decoder = JSONDecoder()
    
    init() {
        print("OrdersInProgressViewModel - connect")
        let ref = Database.database(url: dbURLConnection).reference().child(ordersCollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
            guard let tablesInfo = snapshot.value as? [String: Any] else { return}
            for table in tablesInfo {
                do {
                    let singleTableInfo = tablesInfo[table.key]! as? [String: Any]
                    for j in singleTableInfo! {
                        if j.key == "dishes" {
                            let dishes = singleTableInfo![j.key]! as? [String: Any]
                            for dish in dishes! {
                                let jsonDishData = dishes![dish.key]! as? [String: Any]
                                let dishData =  try JSONSerialization.data(withJSONObject: jsonDishData!)
                                let dish = try JSONDecoder().decode(Dish.self, from: dishData)
                                
                                self.singleTableOrders.append(dish)
                            }
                        }
                    }
                    self.tabledishesDict[table.key] = self.singleTableOrders
                    self.singleTableOrders.removeAll()
                } catch let error {
                    print(error)
                }
            }
        })
    }
    
    func countTotal(menu : [Menu]) -> Double {
        var acc : Double = 0.0
        
        for m in menu {
            if currentOrder[m.dishName] != nil {
                acc += Double(currentOrder[m.dishName]!) * m.dishPrice
            }
        }
        
        return acc
    }
    
    /**
        Get all dish, which are asossiated with choosen tableNumber
     
     - Parameter number : the unique number of the table from which we want to get dishes
     
     - Return : the current dish, which were added to the table
     */
    func getDishesToTisch(number: Int) -> [Dish] {
        return self.tabledishesDict["table\(number)"] ?? []
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
        let ds : [Dish] = self.tabledishesDict["table\(number)"] ?? [] // in case, the table's orders are empty, it is nothing to fetch from firebase
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

        var counter = 0
        for t in tmp {
            let d = [
                "dishName" : t.key,
                "dishAmount" : t.value
            ] as [String: Any]
            ref.child("table\(number)").child("dishes").child("dish\(counter)").setValue(d)
            counter += 1
        }
    }
    
    func decreaseAmountOfDish(dishName : String) -> Void {
        self.currentOrder[dishName] = self.currentOrder[dishName]! - 1
    }
    
    func increaseAmountOfDish(dishName : String) -> Void {
        print(self.currentOrder[dishName]!.description)
        self.currentOrder[dishName] = self.currentOrder[dishName]! + 1
        print(self.currentOrder[dishName]!.description)
    }
    
    func getAmountOfDish(dishName : String) -> Int {
        return self.currentOrder[dishName]!
    }
    
    /**
        Update a value of dishname. If a dish does not yet exist, add new dish. Otherwise, update the current value to new value
     
    - Parameter dishName : Name of dish, which we want to synchonized
     */
    func updateOrder(dishName : String) -> Void {
        let currentAmount = self.currentOrder[dishName] ?? 0
        // up-to-date MVVM
        self.currentOrder.updateValue(currentAmount + 1, forKey: dishName)
    }
    
    /**
        Clear current open order
     */
    func clearCurrentOrderState() -> Void {
        self.currentOrder = [:]
    }
    
    /**
        Remove all orders from table's order and pay from dishes

     - Parameter tableNumber : the unique number of table, from which we want to delete dishes and simulate paying
     */
    func payTable(tableNumber : Int) -> Void {
        let ref = Database.database(url: dbURLConnection ).reference().child(ordersCollectionName)
        ref.child("table\(tableNumber)").child("dishes").removeValue()
        tabledishesDict.removeValue(forKey: "table\(tableNumber)")
    }
}

