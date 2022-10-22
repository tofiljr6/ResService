//
//  WaiterOrderView.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/10/2022.
//

import SwiftUI
import Firebase

let ordersCollectionName = "ordersCollection"
let dbURLConnection = "https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/"

var currentOrder: [String: Int] = [:]
var localDishes : [Dish2] = []

struct WaiterOrderView: View {
    @ObservedObject var progress : OrdersInProgress
    @ObservedObject var OO_orderInKitchen : OrdersInKitchen
    @State var tableNumber = 1
    
    let data : [String] = ["Classic Curry Wurst", "Kult Curry Wurst", "Wild Bradwurst", "Vege Curry Wurst", "Pommes"]
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Table number: \(tableNumber)")
                    .padding(.leading)
                Spacer()
                NavigationLink(destination: SelectTableView(currentTable: $tableNumber)) {
                    Text("Change")
                }.padding(.trailing)
            }.font(.title)
    
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(data, id: \.self) { item in
                    DishView(dishName: item) {
                        addToOrder(productName: item)
                        let currentAmount = progress.currentOrder[item] ?? 0
                        
                        // up-to-date model view controller
                        progress.currentOrder.updateValue(currentAmount + 1, forKey: item)
                    }
                }
            }
            
            Spacer()
            
            HStack{
                Text("Current")
                Spacer()
                Text("XYZ")
            }.padding()
            
            HStack {
                FunctionBoxView(functionName: "Order") {
                    progress.addDishesToTisch(number: tableNumber)
                }
                FunctionBoxView(functionName: "Pay") {
                    payTable(tableNumber: tableNumber)
                }
                FunctionBoxView(functionName: "TEST") {
                    OO_orderInKitchen.addOrder(tableNumber: tableNumber,
                                               currentOrder: progress.currentOrder)
                }
                Button("click") {
                    OO_orderInKitchen.getSorted()
                } 
            }
        }
    }
    
    func payTable(tableNumber: Int) {
        let ref = Database.database(url: dbURLConnection ).reference().child(ordersCollectionName)
        ref.child("table\(tableNumber)").child("dishes").removeValue()
        self.progress.tabledishesDict.removeValue(forKey: "table\(tableNumber)")
    }
}

func addToOrder(productName: String) {
    let currentAmount = currentOrder[productName] ?? 0
    currentOrder.updateValue(currentAmount + 1, forKey: productName)
}



struct WaiterOrderView_Previews: PreviewProvider {
    static var previews: some View {
        WaiterOrderView(progress: OrdersInProgress(),
                        OO_orderInKitchen: OrdersInKitchen())
    }
}


struct Dish : Codable {
    let dishName : String
    let dishAmount : Int
}


