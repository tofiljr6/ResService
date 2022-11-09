//
//  ConsumerMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuView: View {
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ConsumerMenuSectionView(sectionName: "Starters", category: .starter).environmentObject(self.userModel)
                ConsumerMenuSectionView(sectionName: "Main Course", category: .maincourse).environmentObject(self.userModel)
                ConsumerMenuSectionView(sectionName: "Deserts", category: .deserts).environmentObject(self.userModel)
                ConsumerMenuSectionView(sectionName: "Drinks", category: .drinks).environmentObject(self.userModel)
            }
        }.navigationViewStyle(.stack)
    }
}

struct ConsumerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerMenuView().environmentObject(MenuViewModel())
    }
}
