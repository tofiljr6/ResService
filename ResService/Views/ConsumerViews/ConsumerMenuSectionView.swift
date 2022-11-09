//
//  MenuSection.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuSectionView: View {
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuViewMode : MenuViewModel
    var sectionName : String
    var category : DishCategory
    
    var body: some View {
        if menuViewMode.getDishesOfCategory(category: category).count != 0 {
            VStack(alignment: .leading) {
                Text(sectionName)
                    .font(.title2)
                    .padding(.leading, 15)
                    .padding(.top, 15)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(menuViewMode.getDishesOfCategory(category: category), id: \.dishID) { dish in
                            NavigationLink(destination: ConsumerMenuDetailView(dishDetail: dish)
                                .environmentObject(self.userModel)) {
                                ConsumerMenuSingleCardView(menu: dish)
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
        ConsumerMenuSectionView(sectionName: "Wurst", category: .drinks).environmentObject(menuViewModel)
    }
}
