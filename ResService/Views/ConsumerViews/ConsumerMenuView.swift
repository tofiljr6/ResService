//
//  ConsumerMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuView: View {
    @ObservedObject var menuModel : MenuViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ConsumerMenuSectionView(sectionName: "Starters", dishesInSection: menuModel.getDishesOfCategory(category: .starter))
                ConsumerMenuSectionView(sectionName: "Main Course", dishesInSection: menuModel.getDishesOfCategory(category: .maincourse))
                ConsumerMenuSectionView(sectionName: "Deserts", dishesInSection: menuModel.getDishesOfCategory(category: .deserts))
                ConsumerMenuSectionView(sectionName: "Drinks", dishesInSection: menuModel.getDishesOfCategory(category: .drinks))
            }
        }
    }
}

struct ConsumerMenuView_Previews: PreviewProvider {
    @ObservedObject static var menuModel : MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        ConsumerMenuView(menuModel: menuModel)
    }
}
