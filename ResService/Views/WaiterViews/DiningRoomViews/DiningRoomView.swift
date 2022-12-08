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
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    @State var editMode : Bool = false
    @State var editModeInfo : String = "Edit"
    @State var notificationCenterIsShowing : Bool = false
        
    var body: some View {
        NavigationView {
            ZStack {
                ForEach(diningRoom.tablesInfo, id: \.id) { item in
                    TableView(tableInfo: item, editMode: $editMode, diningRoom: diningRoom).environmentObject(menuModel).environmentObject(ordersInProgress).environmentObject(ordersInKitchen)
                }
            }.toolbar {
                HStack{
                    if notificationViewModel.notificationArray.count != 0 {
                        Button {
                            print("show")
                            notificationCenterIsShowing = true
                        } label: {
                            Text(notificationViewModel.notificationArray.count.description)
                            Image(systemName: "bell.fill")
                        }
                    } else {
                        Button {
                            print("none")
                        } label: {
                            Image(systemName: "bell")
                        }
                    }
                    
                    Button {
                        userModel.signout()
                    } label: {
                        Image(systemName: "person.badge.minus").foregroundColor(.red)
                    }
                }
            }.fullScreenCover(isPresented: $userModel.userIsLoggedIn, content: {
                SignInView().frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .sheet(isPresented: $notificationCenterIsShowing) {
                List {
                    ForEach(notificationViewModel.notificationArray, id: \.orderNumber) { item in
                        HStack {
                            Text(item.tableName)
                            Spacer()
                            Text(item.orderNumber.description)
                        }
                    }.onDelete(perform: notificationViewModel.remove(at:))
                }
            }
        }
    }
}



struct ManageTablesView_Previews: PreviewProvider {
//    @ObservedObject static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        DiningRoomView().environmentObject(DiningRoomViewModel())
    }
}

