//
//  ManageTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct DiningRoomView: View {
    @ObservedObject var diningRoom : DiningRoomViewModel
    @State var editMode : Bool = false
    @State var editModeInfo : String = "Edit"
        
    var body: some View {
        NavigationView {
            ZStack {
                ForEach(diningRoom.tablesInfo, id: \.id) { item in
                    TableView(tableInfo: item, editMode: $editMode, diningRoom: diningRoom)
                }
            }
        }
    }
}



struct ManageTablesView_Previews: PreviewProvider {
    @ObservedObject static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        DiningRoomView(diningRoom: diningRoom)
    }
}

