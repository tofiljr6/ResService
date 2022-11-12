//
//  ManageTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct DiningRoomView: View {
    @ObservedObject var diningRoom : DiningRoomViewModel
    @EnvironmentObject var userModel : UserModel
    @State var editMode : Bool = false
    @State var editModeInfo : String = "Edit"
        
    var body: some View {
        NavigationView {
            ZStack {
                ForEach(diningRoom.tablesInfo, id: \.id) { item in
                    TableView(tableInfo: item, editMode: $editMode, diningRoom: diningRoom)
                }
            }.toolbar {
                Button {
                    userModel.signout()
                } label: {
                    Image(systemName: "person.badge.minus").foregroundColor(.red)
                }
            }.fullScreenCover(isPresented: $userModel.userIsLoggedIn, content: {
                SignInView().frame(maxWidth: .infinity, maxHeight: .infinity)
            })
        }
    }
}



struct ManageTablesView_Previews: PreviewProvider {
    @ObservedObject static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        DiningRoomView(diningRoom: diningRoom)
    }
}

