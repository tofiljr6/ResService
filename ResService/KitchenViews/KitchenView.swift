//
//  KitchenView.swift
//  ResService
//
//  Created by Mateusz Tofil on 13/10/2022.
//

import SwiftUI

struct KitchenView: View {
    @ObservedObject var progress : OrdersInProgress
    @ObservedObject var OO_orderInKitchen : OrdersInKitchen
    
    var columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    
    var body: some View {
            if UIDevice.current.userInterfaceIdiom == .phone {
                VStack {
                    ScrollView {
                        ForEach(OO_orderInKitchen.P_ordersToDo, id: \.id) { item in
                            OrderCardView(orderInfo: item.info,dishes: item.dishes, color: .green)
                                .onTapGesture(count: 2) {
                                    print("Do usunięcia zamówienie numer \(item.info.orderNumber) z godziny\(item.info.data)")
                                    print("Czekam 4 sekundy")
                                    Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                                        OO_orderInKitchen.removeOrderFromList(order: item.info.orderNumber)
                                        print("usunięty")
                                    }
                                }
                        }
                    }
                }.padding()
            } else { // == .pad
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(OO_orderInKitchen.P_ordersToDo, id: \.id) { item in
                            OrderCardView(orderInfo: item.info,dishes: item.dishes, color: .green)
                                .onTapGesture(count: 2) {
                                    print("Do usunięcia zamówienie numer \(item.info.orderNumber) z godziny\(item.info.data)")
                                    print("Czekam 4 sekundy")
                                    Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                                        OO_orderInKitchen.removeOrderFromList(order: item.info.orderNumber)
                                        print("usunięty")
                                    }
                                }
                        }
                    }
                    Spacer()
                }.padding()
            }
    }
}

struct KitchenView_Previews: PreviewProvider {
    static var previews: some View {
        // mocking orders in progress object, it does not exist another way
        // to represent @observedobject, because in the preview view, is not used
        // connection with firebase
        let progress = OrdersInProgress()
        let OO_orderInKitchen = OrdersInKitchen()
        //        progress.tabledishesDict["table1"] = [Dish2(dishName: "Classic Curry Wurst", dishAmount: 2),
        //                                              Dish2(dishName: "Kult Curry Wurst", dishAmount: 1),
        //                                              Dish2(dishName: "Pommes", dishAmount: 3)]
        //        progress.tabledishesDict["table2"] = [Dish2(dishName: "Wild Bradwurst", dishAmount: 1)]
        
        Group {
            KitchenView(progress: progress, OO_orderInKitchen: OO_orderInKitchen)
                .previewDevice("iPhone SE (3rd generation)").previewDisplayName("iPhone SE 3rd")
            KitchenView(progress: progress, OO_orderInKitchen: OO_orderInKitchen)
                .previewDevice("iPad Pro (12.9-inch) (4th generation)").previewDisplayName("iPad Pro 12.9")
        }
    }
    
    
}
