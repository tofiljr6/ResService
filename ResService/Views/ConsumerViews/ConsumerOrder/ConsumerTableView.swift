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
    
    var w  : CGFloat = UIScreen.main.bounds.width * 0.90
    var h : CGFloat = UIScreen.main.bounds.height * 0.70
    var wo  = manageTableViewWidth
    var ho = manageTableViewHeight
    
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    var body: some View {
        NavigationLink(destination: { ConsumerConfirmOrderView(shouldPopToRootView: self.$shouldPopToRootView, tableID: $tableInfo.id, userOrderModel: userOrderModel).environmentObject(diningRoom)}) {
            ZStack {
                Rectangle()
                    .fill(diningRoom.getColor(id: tableInfo.id))
                    .frame(width: boxsize, height: boxsize)
                    .cornerRadius(4)
                Text(tableInfo.description)
                    .foregroundColor(.black)
            }.navigationTitle("Select table:")
        }.isDetailLink(false).position(x: (w / wo) * tableInfo.location.x,
                                       y: (h / ho) * tableInfo.location.y)
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
