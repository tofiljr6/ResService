//
//  UserOrderModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 11/11/2022.
//

import Foundation

struct UserOrderM  { // TODO: implement this
    var listofOrder : [Int : Int]
    var orderedList : [Int : Int]
}

class UserOrderModel : ObservableObject {
    @Published var listofOrder : [Int : Int] = [:]
    @Published var orderedList : [Int : Int] = [:]
    
    func addToOrder(menu : Int, amount : Int) -> Void {
        self.listofOrder[menu] = amount
    }
    
    func deleteOrder(menu : Int) -> Void {
        self.listofOrder.removeValue(forKey: menu)
    }
    
    func getAmountToOrder(menu : Int) -> Int {
        return listofOrder[menu] ?? 0
    }
    
    func deleteFromCurrentOrder(menu : Menu) -> Void {
        
    }
    
    func deleteCurrentOrder() -> Void {
        self.listofOrder = [:]
    }
    
    func resignOrderToOrdered() -> Void {
        for (key, value) in self.listofOrder {
            self.orderedList[key] = value + (self.orderedList[key] ?? 0)
        }
        self.listofOrder = [:]
    }
}
