//
//  ManageTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct DiningRoomView: View {
    @ObservedObject var diningRoom : DiningRoomViewModel
    @State var diningRoomViewWidth  = UIScreen.main.bounds.width * 0.8
    @State var diningRoomViewHeight = UIScreen.main.bounds.height * 0.8
    @State var editMode : Bool = false
    @State var editModeInfo : String = "Edit"
        
    var body: some View {
        NavigationView {
            ZStack {
                ForEach(diningRoom.tablesInfo, id: \.id) { item in
                    //                    NavigationLink(destination: { Text(item.id.description)}) {
                    //                        Text(item.id.description).padding().border(.orange)
                    //                    }.position(item.location)
                    TableView(id: item.id, color: item.status, location: item.location,
                              manageTableViewWidth: $diningRoomViewWidth,
                              manageTableViewHeight: $diningRoomViewHeight, editMode: $editMode,
                              diningRoom: diningRoom)
                }
            }
        }
    }
    
    private  func editModeText() {
        editMode.toggle()
        if editMode == false {
            editModeInfo = "Edit"
        } else {
            editModeInfo = "Done"
        }
    }
}



struct ManageTablesView_Previews: PreviewProvider {
    @ObservedObject static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        DiningRoomView(diningRoom: diningRoom)
    }
}

