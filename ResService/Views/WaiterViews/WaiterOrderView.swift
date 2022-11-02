//
//  WaiterOrderView.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/10/2022.
//

import SwiftUI
import Firebase

var currentOrder: [String: Int] = [:]
var localDishes : [Dish] = []

struct WaiterOrderView: View {
    @ObservedObject var ordersInProgress : OrdersInProgressViewModel
    @ObservedObject var ordersInKitchen : OrdersInKitchenViewModel
    @ObservedObject var menu : MenuViewModel
    
    @State var tableNumber = 1
    
    init() {
        self.ordersInProgress = OrdersInProgressViewModel()
        self.ordersInKitchen = OrdersInKitchenViewModel()
        self.menu = MenuViewModel()
    }
    
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
                ForEach(self.menu.menuDishes, id: \.dishID) { item in
                    DishView(dishName: item.dishName) {
                        ordersInProgress.updateOrder(dishName: item.dishName)
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
                    ordersInProgress.addDishesToTisch(number: tableNumber)
                    ordersInKitchen.addOrder(tableNumber: tableNumber,
                                               currentOrder: ordersInProgress.currentOrder)
                    ordersInProgress.clearCurrentOrderState()
                }
                FunctionBoxView(functionName: "Pay") {
                    ordersInProgress.payTable(tableNumber: tableNumber)
                }
            }
        }
    }
}


struct WaiterOrderView_Previews: PreviewProvider {
    static var previews: some View {
        WaiterOrderView()
    }
}
