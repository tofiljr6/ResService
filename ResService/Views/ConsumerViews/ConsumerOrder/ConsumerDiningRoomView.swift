//
//  ConsumerDiningRoomView.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import SwiftUI

struct ConsumerDiningRoomView: View {
    @EnvironmentObject var diningRoom : DiningRoomViewModel
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    @ObservedObject var userOrderModel : UserOrderModel
    @Binding var rootIsActive : Bool

    var manageTableViewWidth  : CGFloat = UIScreen.main.bounds.width * 0.90
    var manageTableViewHeight : CGFloat = UIScreen.main.bounds.height * 0.70
    
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    ForEach(diningRoom.tablesInfo, id: \.id) { item in
                        ConsumerTableView(tableInfo: item, shouldPopToRootView: self.$rootIsActive, userOrderModel : userOrderModel)
                            .environmentObject(userModel)
                    }
                }.frame(width: manageTableViewWidth, height: manageTableViewHeight)
            }
        }
    }
}

struct ConsumerDiningRoomView_Previews: PreviewProvider {
    @State static var rootIsActive : Bool = false
    static var userOrderModel : UserOrderModel = UserOrderModel()
    
    static var previews: some View {
        NavigationView {
            TabView {
                ConsumerDiningRoomView(userOrderModel: userOrderModel, rootIsActive: $rootIsActive)
                    .environmentObject(UserModel()).environmentObject(DiningRoomViewModel())
                    .previewDevice("iPhone 11 Pro").previewDisplayName("iPhone 11 Pro")
                    .tabItem {
                        Label("Order", systemImage: "cart.circle.fill")
                        
                    }
            }.navigationTitle("Select table:")
        }
    }
}
