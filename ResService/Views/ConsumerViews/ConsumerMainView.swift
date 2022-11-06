//
//  MainConsumerView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMainView: View {
    @ObservedObject var userModel : UserModel
    @ObservedObject var menuModel : MenuViewModel = MenuViewModel()
    
    var body: some View {
        VStack {
            TabView {
                ConsumerMenuView(menuModel : menuModel)
                    .tabItem {
                        Label("Menu", systemImage: "menucard")
                    }
                Text("2")
                    .tabItem {
                        Label("View 2", systemImage: "photo")
                    }
                Text("3")
                    .tabItem {
                        Label("View 2", systemImage: "photo")
                    }
            }
        }
    }
}

struct MainConsumerView_Previews: PreviewProvider {
    @ObservedObject static var userModel : UserModel = UserModel()
    
    static var previews: some View {
        ConsumerMainView(userModel: userModel)
    }
}
