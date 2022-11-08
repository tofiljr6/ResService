//
//  MainConsumerView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMainView: View {
    @StateObject var userModel = UserModel()
    @ObservedObject var menuModel : MenuViewModel = MenuViewModel()
    
    var body: some View {
        VStack {
            TabView {
                ConsumerMenuView(menuModel : menuModel).environmentObject(self.userModel)
                    .tabItem {
                        Label("Menu", systemImage: "menucard")
                    }
                ConsumerListOfOrders().environmentObject(self.userModel).environmentObject(self.menuModel)
                    .tabItem {
                        Label("View 2", systemImage: "cart.circle.fill")
                    }
//                Text("3")
//                    .tabItem {
//                        Label("View 2", systemImage: "photo")
//                    }
            }.onAppear {
                // ios 15 bug - transparent tabview - fixed
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}

//struct MainConsumerView_Previews: PreviewProvider {
//    @StateObject  var userModel : UserModel = UserModel()
//
//    static var previews: some View {
//        ConsumerMainView().environmentObject(userModel)
//    }
//}
