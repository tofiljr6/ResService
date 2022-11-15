//
//  OrderPreviewView.swift
//  ResService
//
//  Created by Mateusz Tofil on 15/11/2022.
//

import SwiftUI

struct OrderPreviewView: View {
    @EnvironmentObject var ordersInProgress : OrdersInProgressViewModel
    @State var number : Int
    
    var body: some View {
        if ordersInProgress.currentOrder.count != 0 || ordersInProgress.getDishesToTisch(number: number).count != 0 {
            List {
                if ordersInProgress.currentOrder.count != 0 {
                    Section {
                        ForEach(ordersInProgress.currentOrder.sorted(by: >), id: \.key) { key, value in
                            HStack {
                                Text(key)
                                Spacer()
                                HStack {
                                    Button {
                                        print("descre")
                                        ordersInProgress.decreaseAmountOfDish(dishName: key)
                                    } label: {
                                        Image(systemName: "minus.circle")
                                    }.buttonStyle(BorderlessButtonStyle())
                                    Text(ordersInProgress.getAmountOfDish(dishName: key).description)
                                    Button {
                                        print("increase")
                                        ordersInProgress.increaseAmountOfDish(dishName: key)
                                    } label: {
                                        Image(systemName: "plus.circle")
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                    } header: {
                        Text("Current order")
                    }
                }
                
                if ordersInProgress.getDishesToTisch(number: number).count != 0 {
                    Section {
                        ForEach(Array(ordersInProgress.getDishesToTisch(number: number)), id: \.dishName) { dish in
                            HStack {
                                Text(dish.dishName)
                                Spacer()
                                Text(dish.dishAmount.description)
                            }
                        }
                    } header: {
                        Text("Tables order")
                    }
                }
            }
        } else {
            Text("The order has not yet been taken")
        }
    }
}

struct OrderPreviewView_Previews: PreviewProvider {
    static var number : Int = 0
    
    static var previews: some View {
        OrderPreviewView(number: number)
    }
}
