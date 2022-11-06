//
//  TableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct TableView: Table {
    @State var tableInfo : TableInfo
    @Binding var manageTableViewWidth  : CGFloat
    @Binding var manageTableViewHeight : CGFloat
    @Binding var editMode : Bool
    @ObservedObject var diningRoom : DiningRoomViewModel
    
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    var body: some View {
        NavigationLink(destination: { WaiterOrderView(tableInfo: tableInfo)}) {
            ZStack {
                Rectangle()
                    .fill(.green)
                    .frame(width: boxsize, height: boxsize)
                    .cornerRadius(4)
                Text(tableInfo.description)
                    .foregroundColor(.black)
            }
        }.position(tableInfo.location)
    }
}

struct TableView_Previews: PreviewProvider {
    @State static var manageTableViewHeight = UIScreen.main.bounds.height * 0.8
    @State static var manageTableViewWidth = UIScreen.main.bounds.width * 0.8
    @State static var editMode : Bool = false
    @ObservedObject static var manageTable = DiningRoomViewModel()

    static var previews: some View {
        TableView(tableInfo: TableInfo(id: 1,
                                       status: .brown,
                                       location: CGPoint(x: 50, y: 50),
                                       description: "A"),
                  manageTableViewWidth: $manageTableViewWidth,
                  manageTableViewHeight: $manageTableViewHeight, editMode: $editMode,
                  diningRoom: manageTable)
    }
}
