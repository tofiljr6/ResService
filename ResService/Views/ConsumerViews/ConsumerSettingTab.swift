//
//  ConsumerSettingTab.swift
//  ResService
//
//  Created by Mateusz Tofil on 10/11/2022.
//

import SwiftUI

struct ConsumerSettingTab: View {
    @EnvironmentObject var userModel : UserModel
    
    var body: some View {
        HStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                userModel.signout()
            } label: {
                Text("Sign out")
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
