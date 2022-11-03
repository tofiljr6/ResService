//
//  ManageDiningRoomView.swift
//  ResService
//
//  Created by Mateusz Tofil on 03/11/2022.
//

import SwiftUI

struct ManageDiningRoomView: View {
    @ObservedObject var diningRoom : DiningRoomViewModel
    @State var diningRoomViewWidth  = UIScreen.main.bounds.width * 0.8
    @State var diningRoomViewHeight = UIScreen.main.bounds.height * 0.8
    @State var editMode : Bool = false
    @State var editModeInfo : String = "Edit"
    
    var body: some View {
        ZStack {
            ForEach(diningRoom.tablesInfo, id: \.id) { item in
                TableInManageDiningRoomView(id: item.id, color: item.color, location: item.location,
                                            manageTableViewWidth: $diningRoomViewWidth, manageTableViewHeight: $diningRoomViewHeight,
                                            editMode: $editMode, diningRoom: diningRoom)
            }
        }
    }
}

struct ManageDiningRoomView_Previews: PreviewProvider {
    @ObservedObject static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        ManageDiningRoomView(diningRoom: diningRoom)
    }
}
