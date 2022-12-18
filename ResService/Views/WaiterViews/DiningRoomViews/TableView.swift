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
    
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    var w  : CGFloat = UIScreen.main.bounds.width * 1.00
    var h : CGFloat?
    var wo = manageTableViewWidth
    var ho = manageTableViewHeight
        
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
//            .position(x: (w / wo) * tableInfo.location.x,
//                      y: ((h ?? UIScreen.main.bounds.height * 0.90 ) / ho) * tableInfo.location.y)
        }.isDetailLink(false)
//        .position(tableInfo.location)
        .position(x: (w / wo) * tableInfo.location.x,
                  y: ((h ?? UIScreen.main.bounds.height * 0.90 ) / ho) * tableInfo.location.y)

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
