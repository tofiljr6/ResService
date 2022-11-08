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
    @StateObject var diningRoomModel : DiningRoomViewModel = DiningRoomViewModel()
    @State var isActive : Bool = false
    
    @State var isDiningRoomShowing : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if userModel.listofOrder.count == 0 {
                    Text("Select dishes to see your order")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(userModel.listofOrder.sorted(by: >), id: \.key) { key, value in
                            HStack {
                                Text(menuModel.getMenuByID(id: key)!.dishName)
                                Spacer()
                                Text("\(value.description) x \(String(format: "%.2f", menuModel.getMenuByID(id: key)!.dishPrice))")
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
                                // TODO: cancel the order
                                print("cancel")
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
                            NavigationLink(destination: ConsumerDiningRoomView(rootIsActive: self.$isActive).environmentObject(diningRoomModel), isActive: self.$isActive) {
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
                            .navigationTitle("Your order")
                        }
                    }
                }
            }
        }
    }
    
    
    func countTotal() -> Double {
        var acc = 0.0
        
        for dish in userModel.listofOrder {
            acc += ( menuModel.getMenuByID(id: dish.key)!.dishPrice * Double(dish.value))
        }
        
        return acc
    }
}

struct ConsumerListOfOrders_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConsumerListOfOrders().environmentObject(UserModel())
                .navigationTitle("Your order")
        }
    }
}
