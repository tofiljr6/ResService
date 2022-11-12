//
//  ConsumerTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import SwiftUI

struct ConsumerTableView: View {
    @State var tableInfo : TableInfo
    @Binding var shouldPopToRootView : Bool
    @ObservedObject var userOrderModel : UserOrderModel
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    @EnvironmentObject var diningRoom : DiningRoomViewModel
    
    var manageTableViewWidth  : CGFloat = UIScreen.main.bounds.width * 0.8
    var manageTableViewHeight : CGFloat =  UIScreen.main.bounds.height * 0.8
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    var body: some View {
//        NavigationLink(destination: { ConsumerConfirmOrderView(userModel : self.$shouldPopToRootView, menuModel : $tableInfo.id, diningRoomModel : userOrderModel).environmentObject(userModel)}) {
        NavigationLink(destination: { ConsumerConfirmOrderView(shouldPopToRootView: self.$shouldPopToRootView, tableID: $tableInfo.id, userOrderModel: userOrderModel)}) {
            ZStack {
                Rectangle()
                    .fill(.green)
                    .frame(width: boxsize, height: boxsize)
                    .cornerRadius(4)
                Text(tableInfo.description)
                    .foregroundColor(.black)
            }.navigationTitle("Select table:")
        }.isDetailLink(false).position(tableInfo.location)
    }
}

struct ConsumerTableView_Previews: PreviewProvider {
    @State static var shouldPopToRootView : Bool = false
    static var userOrderModel : UserOrderModel = UserOrderModel()

    static var previews: some View {
        NavigationView {
            ConsumerTableView(tableInfo: TableInfo(id: 1,
                                               status: .brown,
                                               location: CGPoint(x: 50, y: 50),
                                               description: "A"), shouldPopToRootView: $shouldPopToRootView, userOrderModel: userOrderModel)
            .environmentObject(UserModel()).environmentObject(MenuViewModel()).environmentObject(DiningRoomViewModel())
            .navigationTitle("Select table:")
        }
    }
}
