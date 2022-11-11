//
//  ConsumerMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuView: View {
    @EnvironmentObject var userModel : UserModel
//    @StateObject var userOrderModel = UserOrderModel()
    @ObservedObject var userOrderModel : UserOrderModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ConsumerMenuSectionView(userOrderModel: userOrderModel, sectionName: "Starters", category: .starter).environmentObject(self.userOrderModel)
                ConsumerMenuSectionView(userOrderModel: userOrderModel, sectionName: "Main Course", category: .maincourse).environmentObject(self.userOrderModel)
                ConsumerMenuSectionView(userOrderModel: userOrderModel, sectionName: "Deserts", category: .deserts).environmentObject(self.userOrderModel)
                ConsumerMenuSectionView(userOrderModel: userOrderModel, sectionName: "Drinks", category: .drinks).environmentObject(self.userOrderModel)
            }.navigationTitle("Hello, \(userModel.username)")
        }.navigationViewStyle(.stack)
    }
}

struct ConsumerMenuView_Previews: PreviewProvider {
    static var userOrderModel : UserOrderModel = UserOrderModel()
    
    static var previews: some View {
        ConsumerMenuView(userOrderModel: userOrderModel).environmentObject(MenuViewModel())
    }
}
