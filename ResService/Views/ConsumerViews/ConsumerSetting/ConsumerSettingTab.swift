//
//  ConsumerSettingTab.swift
//  ResService
//
//  Created by Mateusz Tofil on 10/11/2022.
//

import SwiftUI

struct ConsumerSettingTab: View {
    @EnvironmentObject var userModel : UserModel
    
    var menuItem : [MenuItem] = [MenuItem(id: UUID(), name: "Order history")]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(menuItem, id: \.id) { item in
                    NavigationLink(destination: Text(item.name)) {
                        Text(item.name)
                    }
                }
            }.navigationTitle("Settings")
                .toolbar {
                    Button {
                        userModel.signout()
                    } label: {
                        Image(systemName: "person.badge.minus").foregroundColor(.red)
                    }

                }
        }.fullScreenCover(isPresented: $userModel.userIsLoggedIn, content: {
            SignInView().frame(maxWidth: .infinity, maxHeight: .infinity)
        })
    }
}

struct ConsumerSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerSettingTab().environmentObject(UserModel())
    }
}
