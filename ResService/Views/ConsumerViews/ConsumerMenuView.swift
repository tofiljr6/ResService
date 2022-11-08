//
//  ConsumerMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuView: View {
    @EnvironmentObject var userModel : UserModel
    @ObservedObject var menuModel : MenuViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ConsumerMenuSectionView(sectionName: "Starters", dishesInSection: menuModel.getDishesOfCategory(category: .starter), menuViewModel: menuModel).environmentObject(self.userModel)
                ConsumerMenuSectionView(sectionName: "Main Course", dishesInSection: menuModel.getDishesOfCategory(category: .maincourse), menuViewModel: menuModel).environmentObject(self.userModel)
                ConsumerMenuSectionView(sectionName: "Deserts", dishesInSection: menuModel.getDishesOfCategory(category: .deserts), menuViewModel: menuModel).environmentObject(self.userModel)
                ConsumerMenuSectionView(sectionName: "Drinks", dishesInSection: menuModel.getDishesOfCategory(category: .drinks), menuViewModel: menuModel).environmentObject(self.userModel)
            }
        }.navigationViewStyle(.stack)
    }
}

struct ConsumerMenuView_Previews: PreviewProvider {
    @ObservedObject static var menuModel : MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        ConsumerMenuView(menuModel: menuModel)
    }
}
