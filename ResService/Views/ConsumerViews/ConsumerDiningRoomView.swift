//
//  ConsumerDiningRoomView.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import SwiftUI

struct ConsumerDiningRoomView: View {
    @EnvironmentObject var diningRoom : DiningRoomViewModel
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    @ObservedObject var userOrderModel : UserOrderModel
    @Binding var rootIsActive : Bool

    var body: some View {
        ZStack {
            ForEach(diningRoom.tablesInfo, id: \.id) { item in
                ConsumerTableView(tableInfo: item, shouldPopToRootView: self.$rootIsActive, userOrderModel : userOrderModel)
                    .environmentObject(userModel)
            }
        }
    }
}

struct ConsumerDiningRoomView_Previews: PreviewProvider {
    @State static var rootIsActive : Bool = false
    static var userOrderModel : UserOrderModel = UserOrderModel()
    
    static var previews: some View {
        ConsumerDiningRoomView(userOrderModel: userOrderModel, rootIsActive: $rootIsActive)
            .environmentObject(UserModel())
    }
}
