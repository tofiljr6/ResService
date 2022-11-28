//
//  WaiterOrderView.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/10/2022.
//

import SwiftUI
import Firebase

struct WaiterOrderView: View {
    @EnvironmentObject var ordersInProgress : OrdersInProgressViewModel
    @EnvironmentObject var ordersInKitchen : OrdersInKitchenViewModel
    @EnvironmentObject var menu : MenuViewModel
    
    @State var tableInfo : TableInfo
    @ObservedObject var diningRoomModel : DiningRoomViewModel
    
    @State var isOrderDetailShowing : Bool = false
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Table number: \(tableInfo.description)")
                    .padding(.leading)
                Spacer()
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
                Text("\(String(format: "%.2f", ordersInProgress.countTotal(menu: menu.menuDishes)))")
            }.padding()
            
            HStack {
                FunctionBoxView(functionName: "Order") {
                    ordersInProgress.addDishesToTisch(number: tableInfo.id)
                    ordersInKitchen.addOrder(tableNumber: tableInfo.id,
                                               currentOrder: ordersInProgress.currentOrder)
                    ordersInProgress.clearCurrentOrderState()
                    
                    // occupy table
                    diningRoomModel.setTableStatus(number: tableInfo.id, color: "red")
                }
                FunctionBoxView(functionName: "Pay") {
                    ordersInProgress.payTable(tableNumber: tableInfo.id)
                    
                    // make table free
                    diningRoomModel.setTableStatus(number: tableInfo.id, color: "green")
                }
                FunctionBoxView(functionName: "Preview") {
                    isOrderDetailShowing.toggle()
                }
            }
        }.sheet(isPresented: $isOrderDetailShowing) {
            OrderPreviewView(number: tableInfo.id).environmentObject(ordersInProgress)
        }.onDisappear {
            ordersInProgress.clearCurrentOrderState()
        }
    }
}


struct WaiterOrderView_Previews: PreviewProvider {
    @State static var tableNumber : Int = 1
    static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        WaiterOrderView(
            tableInfo: TableInfo(id: 1,
                                 status: .green,
                                 location: CGPoint(x: 40, y: 40),
                                 description: "D"), diningRoomModel: diningRoom)
    }
}
