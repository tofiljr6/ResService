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
        ScrollView {
            ConsumerMenuSectionView(sectionName: "Wurst", dishesInSection: menuModel.menuDishes)
            ConsumerMenuSectionView(sectionName: "Wurst", dishesInSection: menuModel.menuDishes)
            ConsumerMenuSectionView(sectionName: "Wurst", dishesInSection: menuModel.menuDishes)
        }
    }
}

struct ConsumerMenuView_Previews: PreviewProvider {
    @ObservedObject static var menuModel : MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        ConsumerMenuView(menuModel: menuModel)
    }
}
