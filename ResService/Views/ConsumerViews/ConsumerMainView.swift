//
//  MainConsumerView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMainView: View {
    @StateObject var userModel = UserModel()
    // the userModel can not be @EnvironmentObject because
    // models operations are subject to constant change and
    // each time the  variables are changed, the view is
    // generated anew
    @EnvironmentObject var menuModel : MenuViewModel
    
    var body: some View {
        VStack {
            TabView {
                ConsumerMenuView().environmentObject(self.userModel)
                    .tabItem {
                        Label("Menu", systemImage: "menucard")
                    }
                ConsumerListOfOrders().environmentObject(self.userModel)
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
}

struct MainConsumerView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerMainView().environmentObject(MenuViewModel())
    }
}
