//
//  MenuSection.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuSectionView: View {
    
    var sectionName : String
    var dishesInSection : [Menu]
    var menuViewModel : MenuViewModel
    
    var body: some View {
        if dishesInSection.count != 0 {
            VStack(alignment: .leading) {
                Text(sectionName)
                    .font(.title2)
                    .padding(.leading, 15)
                    .padding(.top, 15)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(dishesInSection, id: \.dishID) { dish in
//                            MenuSingleCardView(menu: dish)
                            NavigationLink(destination: ConsumerMenuDetailView(dishDetail: dish, menuViewModel: menuViewModel)) {
                                ConsumerMenuSingleCardView(menu: dish, menuViewModel: menuViewModel)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ConsumerMenuSectionView_Previews: PreviewProvider {
    static var menuViewModel = MenuViewModel()
    
    static var previews: some View {
        ConsumerMenuSectionView(sectionName: "Wurst", dishesInSection: [
            Menu(dishID: 1, dishDescription: "Lorem Impsum", dishName: "Curry Wurst", dishPrice: 4.90, dishProducts: "da", dishOrderInMenu: 1, dishCategory: "starter", dishPhotoURL: UUID().uuidString),
            Menu(dishID: 2, dishDescription: "Lorem Impsum", dishName: "Kult Wurst", dishPrice: 4.90, dishProducts: "da", dishOrderInMenu: 1, dishCategory: "starter", dishPhotoURL: UUID().uuidString),
            Menu(dishID: 3, dishDescription: "Lorem Impsum", dishName: "Wild Bradwurst", dishPrice: 4.90, dishProducts: "da", dishOrderInMenu: 1, dishCategory: "starter", dishPhotoURL: UUID().uuidString),
            Menu(dishID: 4, dishDescription: "Lorem Impsum", dishName: "Vege", dishPrice: 4.90, dishProducts: "da", dishOrderInMenu: 1, dishCategory: "starter", dishPhotoURL: UUID().uuidString)
        ], menuViewModel: menuViewModel
        )
    }
}
