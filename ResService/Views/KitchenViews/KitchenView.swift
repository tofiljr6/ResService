//
//  KitchenView.swift
//  ResService
//
//  Created by Mateusz Tofil on 13/10/2022.
//

import SwiftUI

struct KitchenView: View {
    @EnvironmentObject var ordersInProgress : OrdersInProgressViewModel
    @EnvironmentObject var ordersInKitchen : OrdersInKitchenViewModel
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var notificationModel : NotificationViewModel
    
    var columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            VStack {
                if userModel.role == "kitchen" {
                    HStack{
                        Spacer()
                        Button {
                            userModel.signout()
                        } label: {
                            Image(systemName: "person.badge.minus")
                                .foregroundColor(.red)
                        }
                    }
                }
                ScrollView {
                    ForEach(ordersInKitchen.P_ordersToDo, id: \.id) { item in
                        OrderCardView(orderInfo: item.info,dishes: item.dishes, color: .green)
                            .onTapGesture(count: 2) {
                                print("Do usunięcia zamówienie numer \(item.info.orderNumber) z godziny\(item.info.data)")
                                print("Czekam 4 sekundy")
                                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                                    ordersInKitchen.removeOrderFromList(order: item.info.orderNumber)
                                    notificationModel.add(orderNumber: item.info.orderNumber, tableName: item.info.table)
                                    print("usunięty")
                                }
                            }
                    }
                }
            }.padding()
            .fullScreenCover(isPresented: $userModel.userIsLoggedIn, content: {
                SignInView()
            })
        } else { // == .pad
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Text("Current orders").font(.title)
                    Spacer()
                    Button {
                        userModel.signout()
                    } label: {
                        Image(systemName: "person.badge.minus")
                            .foregroundColor(.red)
                    }
                }
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(ordersInKitchen.P_ordersToDo, id: \.id) { item in
                        OrderCardView(orderInfo: item.info,dishes: item.dishes, color: .green)
                            .onTapGesture(count: 2) {
                                print("Do usunięcia zamówienie numer \(item.info.orderNumber) z godziny\(item.info.data)")
                                print("Czekam 4 sekundy")
                                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                                    notificationModel.add(orderNumber: item.info.orderNumber, tableName: item.info.table)
                                    ordersInKitchen.removeOrderFromList(order: item.info.orderNumber)
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
        Group {
//            KitchenView()
//                .previewDevice("iPhone SE (3rd generation)").previewDisplayName("iPhone SE 3rd")
            KitchenView()
                .previewDevice("iPad Pro (12.9-inch) (4th generation)").previewDisplayName("iPad Pro 12.9")        }
                .environmentObject(OrdersInProgressViewModel())
                .environmentObject(OrdersInKitchenViewModel())
                .environmentObject(UserModel())
    }
}
