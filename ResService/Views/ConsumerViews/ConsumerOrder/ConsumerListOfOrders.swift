//
//  ConsumerListOfOrders.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import SwiftUI

struct ConsumerListOfOrders: View {
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    @ObservedObject var ordersInKitchenModel : OrdersInKitchenViewModel = OrdersInKitchenViewModel()
    @ObservedObject var userOrderModel : UserOrderModel
    @StateObject var diningRoomModel : DiningRoomViewModel = DiningRoomViewModel()
    @State var isActive : Bool = false
    
    @State var isDiningRoomShowing : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if userOrderModel.listofOrder.count == 0 && userOrderModel.orderedList.count == 0 {
                    Spacer()
                    Text("Select dishes to see your order")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        Section(header: Text("Current order")) {
                            ForEach(userOrderModel.listofOrder.sorted(by: >), id: \.key) { key, value in
                                HStack {
                                    if let dname = menuModel.getMenuByID(id: key)?.dishName {
                                        Text(dname)
                                    }
                                    Spacer()
                                    if let dprice = menuModel.getMenuByID(id: key)?.dishPrice {
                                        Text("\(value.description) x \(String(format: "%.2f", dprice))")
                                    }
                                }
                            }
                        }
                        
                        Section(header: Text("Ordered")) {
                            ForEach(userOrderModel.orderedList.sorted(by: >), id: \.key) { key, value in
                                
                                HStack {
                                    if let dname = menuModel.getMenuByID(id: key)?.dishName {
                                        Text(dname)
                                    }
                                    Spacer()
                                    if let dprice = menuModel.getMenuByID(id: key)?.dishPrice {
                                        Text("\(value.description) x \(String(format: "%.2f", dprice))")
                                    }
                                }
                            }
                        }
                    }
                
                    VStack {
                        HStack {
                            Text("Total")
                            Spacer()
                            Text("\(String(format: "%.2f", countTotal()))")
                        }.font(Font.body.bold()).padding()
                        
                        HStack {
                            Button {
                                userOrderModel.deleteCurrentOrder()
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(8)
                                        .foregroundColor(.red)
                                        .frame(height: 50)
                                        .padding()
                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .font(Font.body.bold())
                                }
                            }
                            Spacer()
                            
                            // root
                            NavigationLink(destination: ConsumerDiningRoomView(userOrderModel: userOrderModel, rootIsActive: self.$isActive)
                                .environmentObject(diningRoomModel)
                                .environmentObject(userModel)
                                .environmentObject(menuModel), isActive: self.$isActive) {
                                ZStack() {
                                    Rectangle()
                                        .cornerRadius(8)
                                        .foregroundColor(.green)
                                        .frame(height: 50)
                                        .padding()
                                    Text("Take order")
                                        .foregroundColor(.white)
                                        .font(Font.body.bold())
                                }
                            }.isDetailLink(false)
                        }
                    }
                }
            }.navigationTitle("Your order")
        }
    }
    
    
    func countTotal() -> Double {
        var acc = 0.0
        
        for dish in userOrderModel.listofOrder {
            if let price = menuModel.getMenuByID(id: dish.key)?.dishPrice {
                acc += ( price * Double(dish.value))
            } else {
                print(menuModel.menuDishes)
            }
        }
        
        return acc
    }
}

struct ConsumerListOfOrders_Previews: PreviewProvider {
    static var userOrderModel : UserOrderModel = UserOrderModel()
    
    static var previews: some View {
        NavigationView {
            ConsumerListOfOrders(userOrderModel: userOrderModel).environmentObject(UserModel())
                .navigationTitle("Your order")
        }
    }
}
