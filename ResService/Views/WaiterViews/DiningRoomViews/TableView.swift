//
//  TableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct TableView: View {
    @State var tableInfo : TableInfo
    @Binding var editMode : Bool
    @ObservedObject var diningRoom : DiningRoomViewModel
    @EnvironmentObject var menuModel : MenuViewModel
    @EnvironmentObject var ordersInProgress : OrdersInProgressViewModel
    @EnvironmentObject var ordersInKitchen : OrdersInKitchenViewModel
    
    var manageTableViewWidth  : CGFloat = UIScreen.main.bounds.width * 0.8
    var manageTableViewHeight : CGFloat =  UIScreen.main.bounds.height * 0.8
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    var body: some View {
        NavigationLink(destination: { WaiterOrderView(tableInfo: tableInfo, diningRoomModel: diningRoom)
                                        .environmentObject(menuModel)
                                        .environmentObject(ordersInProgress)
                                        .environmentObject(ordersInKitchen)
            
        }) {
            ZStack {
                Rectangle()
//                    .fill(tableInfo.status)
                    .fill(diningRoom.getColor(id: tableInfo.id))
                    .frame(width: boxsize, height: boxsize)
                    .cornerRadius(4)
                Text(tableInfo.description)
                    .foregroundColor(.black)
            }
        }.position(tableInfo.location)
    }
}

struct TableView_Previews: PreviewProvider {
    @State static var editMode : Bool = false
    @ObservedObject static var manageTable = DiningRoomViewModel()

    static var previews: some View {
        TableView(tableInfo: TableInfo(id: 1,
                                       status: .brown,
                                       location: CGPoint(x: 50, y: 50),
                                       description: "A"),
                  editMode: $editMode, diningRoom: manageTable).environmentObject(DiningRoomViewModel())
    }
}