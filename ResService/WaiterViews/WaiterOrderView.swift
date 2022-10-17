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
    
    let object: [String: Any] = [:]
    ref.child("table\(tableNumber)").setValue(object)
}

struct dish {
    let name: String
    let amount: Int
}

func sendSingleOrder(tablesNumber: Int) {
    let ref = Database.database(url: dbURLConnection).reference().child(ordersCollectionName)
    var dishStructs = [dish]()

    ref.child("table\(tablesNumber)").child("dishes").getData(completion:  { error, snapshot in
        guard error == nil else {
            print(error!.localizedDescription)
            return;
        }
        
        // get the data from collectionName into dict
        let alreadyOrdered =  snapshot?.value as? NSDictionary ?? [:]
        
        for key in alreadyOrdered.allKeys {
            if let x = currentOrder[key as! String] {
                if let y = alreadyOrdered.value(forKey: key as! String) as? Int {
                    currentOrder.updateValue(x+y, forKey: key as! String )
                }
            }
        }
        
        for i in currentOrder {
            dishStructs.append(dish.init(name: i.key, amount: i.value))
        }
        
        if !dishStructs.isEmpty {
            for i in 0...dishStructs.count-1 {
                ref.child("table\(tablesNumber)").child("dishes").child(dishStructs[i].name).setValue(dishStructs[i].amount)
            }
        }
        currentOrder.removeAll()
    });
}

struct WaiterOrderView_Previews: PreviewProvider {
    static var previews: some View {
        WaiterOrderView()
    }
}
