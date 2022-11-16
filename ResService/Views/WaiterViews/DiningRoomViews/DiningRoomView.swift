//
//  ManageTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct DiningRoomView: View {
    @StateObject var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    @EnvironmentObject var ordersInProgress : OrdersInProgressViewModel
    @EnvironmentObject var ordersInKitchen : OrdersInKitchenViewModel
    @State var editMode : Bool = false
    @State var editModeInfo : String = "Edit"
        
    var body: some View {
        NavigationView {
            ZStack {
                ForEach(diningRoom.tablesInfo, id: \.id) { item in
                    TableView(tableInfo: item, editMode: $editMode, diningRoom: diningRoom).environmentObject(menuModel).environmentObject(ordersInProgress).environmentObject(ordersInKitchen)
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
        }.onAppear {
            print("represh xd")
        }
    }
}



struct ManageTablesView_Previews: PreviewProvider {
//    @ObservedObject static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        DiningRoomView().environmentObject(DiningRoomViewModel())
    }
}

