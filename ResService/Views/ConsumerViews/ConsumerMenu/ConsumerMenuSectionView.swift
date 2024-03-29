//
//  MenuSection.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuSectionView: View {
    @ObservedObject var userOrderModel : UserOrderModel
    @EnvironmentObject var menuViewMode : MenuViewModel
    var sectionName : String
    var category : DishCategory
    
    var body: some View {
        if menuViewMode.getDishesOfCategory(category: category).count != 0 {
            if menuViewMode.getDishesOfCategory(category: category).count > 1 {
                MultiCategoryView(userOrderModel: userOrderModel, sectionName: sectionName, category: category).environmentObject(menuViewMode)
            } else { // single dish of category
                SingleCategoryView(userOrderModel: userOrderModel, sectionName: sectionName, category: category).environmentObject(menuViewMode)
            }
        }
    }
}

struct SingleCategoryView: View {
    @ObservedObject var userOrderModel : UserOrderModel
    @EnvironmentObject var menuViewMode : MenuViewModel
    var sectionName: String
    var category: DishCategory
    
    lazy var dish = menuViewMode.getDishesOfCategory(category: category)[0]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(sectionName)
                .font(.title2)
                .padding(.leading, 15)
                .padding(.top, 15)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(menuViewMode.getDishesOfCategory(category: category), id: \.dishID) { dish in
                    NavigationLink(destination: ConsumerMenuDetailView(userModel: userOrderModel, dishDetail: dish).environmentObject(self.userOrderModel)) {
                        ConsumerMenuSingleCard2View(menu: dish)
                    }
                }
            }
        }
    }
}

struct MultiCategoryView : View {
    @ObservedObject var userOrderModel : UserOrderModel
    @EnvironmentObject var menuViewMode : MenuViewModel
    var sectionName: String
    var category: DishCategory
    
    var body: some View {
    
        VStack(alignment: .leading) {
            Text(sectionName)
                .font(.title2)
                .padding(.leading, 15)
                .padding(.top, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(menuViewMode.getDishesOfCategory(category: category), id: \.dishID) { dish in
                        NavigationLink(destination: ConsumerMenuDetailView(userModel: userOrderModel, dishDetail: dish).environmentObject(self.userOrderModel)) {
                            ConsumerMenuSingleCardView(menu: dish)
                        }
                    }
                }
            }
        }
    }
}

struct ConsumerMenuSectionView_Previews: PreviewProvider {
    static var userOrderModel : UserOrderModel = UserOrderModel()
    
    static var previews: some View {
        ConsumerMenuSectionView(userOrderModel: userOrderModel, sectionName: "Wurst", category: .drinks).environmentObject(MenuViewModel())
    }
}
