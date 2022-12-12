//
//  MainConsumerView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMainView: View {
    @EnvironmentObject var userModel : UserModel
    // the userModel can not be @EnvironmentObject because
    // models operations are subject to constant change and
    // each time the  variables are changed, the view is
    // generated anew
    @StateObject var userOrderModel : UserOrderModel = UserOrderModel()
    
    var body: some View {
        TabView {
            ConsumerMenuView(userOrderModel: userOrderModel).environmentObject(self.userOrderModel)
                .tabItem {
                    Label("Menu", systemImage: "menucard")
                }
            ConsumerListOfOrders(userOrderModel : userOrderModel).environmentObject(self.userModel)
                .tabItem {
                    Label("Order", systemImage: "cart.circle.fill")
                }
        }.onAppear {
            // ios 15 bug - transparent tabview - fixed
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

struct MainConsumerView_Previews: PreviewProvider {
    static var userModel = UserModel()

    static var previews: some View {
        ConsumerMainView().environmentObject(MenuViewModel())
            .environmentObject(UserModel())
    }
}
