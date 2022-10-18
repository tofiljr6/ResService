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

struct WaiterOrderView: View {
    let data : [String] = ["Classic Curry Wurst", "Kult Curry Wurst", "Wild Bradwurst", "Vege Curry Wurst", "Pommes"]
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    @State var tableNumber = 1
    
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
                    }
                }
            }
            
            Spacer()
            
            HStack{
                Text("Current: ")
                Spacer()
                Text("XYZ")
            }.padding()
            
            HStack {
                FunctionBoxView(functionName: "Order") {
                    sendSingleOrder(tablesNumber: tableNumber)
                }
                FunctionBoxView(functionName: "Pay") {
                    payTable(tableNumber: tableNumber)
                }
            }
        }
    }
}

func addToOrder(productName: String) {
    let currentAmount = currentOrder[productName] ?? 0
    currentOrder.updateValue(currentAmount + 1, forKey: productName)
    print(currentOrder)
}

func payTable(tableNumber: Int) {
    let ref = Database.database(url: dbURLConnection ).reference().child(ordersCollectionName)
    ref.child("table\(tableNumber)").child("dishes").removeValue()
}

func sendSingleOrder(tablesNumber: Int) {
    let ref = Database.database(url: dbURLConnection).reference().child(ordersCollectionName)
    var dishStructs = [Dish]()
    
    ref.child("table\(tablesNumber)").child("dishes").getData(completion:  { error, snapshot in
        guard error == nil else {
            print(error!.localizedDescription)
            return;
        }
        
        guard let json = snapshot?.value as? [String: Any] else {
            // the json file has not been loaded so it must be added only existing orders from
            // the current order. It is usuaully used with first order, where the tables
            // collection is empty
            var i = 0
            for (key, value) in currentOrder {
                let d = [
                    "dishName" : key,
                    "dishAmount" : value
                ]
                ref.child("table\(tablesNumber)").child("dishes").child("dish\(i)").setValue(d)
                i += 1
            }
            currentOrder.removeAll()
            return
        }
        
        // the data is lauched from firebase and is parsered to my struct, which
        // i had before implemented
        for j in json {
            do {
                let ordersData = try JSONSerialization.data(withJSONObject: json[j.key]!)
                let order = try JSONDecoder().decode(Dish.self, from: ordersData)
                dishStructs.append(Dish(dishName: order.dishName, dishAmount: order.dishAmount))
            } catch let error {
                print("an error occurred \(error)")
            }
        }
            
        // make up-to-date orders, in case, the order button was accidentally clicked
        // allthough the order was not completed. It includes also case, which describes
        // situtation, where the client wants to order twice.
        print(currentOrder)
        for dishStruct in dishStructs {
            if currentOrder[dishStruct.dishName] != nil {
                currentOrder[dishStruct.dishName]! += dishStruct.dishAmount
            } else {
                currentOrder[dishStruct.dishName] = dishStruct.dishAmount
            }
        }
        
        // the previos data is synchorinzed with firebase
        var i = 0
        for (key, value) in currentOrder {
            let d = [
                "dishName" : key,
                "dishAmount" : value
            ]
            ref.child("table\(tablesNumber)").child("dishes").child("dish\(i)").setValue(d)
            i += 1
        }
        currentOrder.removeAll()
    });
}

struct WaiterOrderView_Previews: PreviewProvider {
    static var previews: some View {
        WaiterOrderView()
    }
}


struct Dish : Codable {
    let dishName : String
    let dishAmount : Int
}


