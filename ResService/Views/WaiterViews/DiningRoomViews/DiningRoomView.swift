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
            ScrollView {
                VStack {
                    ZStack {
                        ForEach(diningRoom.tablesInfo, id: \.id) { item in
                            if userModel.role == "boss" {
                                TableView(tableInfo: item, editMode: $editMode, diningRoom: diningRoom, h: UIScreen.main.bounds.height * 0.85)
                                    .environmentObject(menuModel).environmentObject(ordersInProgress).environmentObject(ordersInKitchen)
                            } else {
                                TableView(tableInfo: item, editMode: $editMode, diningRoom: diningRoom)
                                    .environmentObject(menuModel).environmentObject(ordersInProgress).environmentObject(ordersInKitchen)
                            }
                        }
                    }
                }.padding(.bottom, UIScreen.main.bounds.height)
            }.toolbar {
                HStack{
                    if notificationViewModel.notificationArray.count != 0 {
                        Button {
                            notificationCenterIsShowing = true
                        } label: {
                            Text(notificationViewModel.notificationArray.count.description)
                            Image(systemName: "bell.fill")
                        }
                    } else {
                        Button {
                            notificationCenterIsShowing = true
                        } label: {
                            Image(systemName: "bell")
                        }
                    }
                    
                    if userModel.role == "waiter" {
                        Button {
                            userModel.signout()
                        } label: {
                            Image(systemName: "person.badge.minus").foregroundColor(.red)
                        }
                    }
                }
            }.fullScreenCover(isPresented: $userModel.userIsLoggedIn, content: {
                SignInView().frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .sheet(isPresented: $notificationCenterIsShowing) {
                SheetView(showSheetView: $notificationCenterIsShowing, notificationViewModel: notificationViewModel)
            }
        }
    }
}


struct SheetView: View {
    @Binding var showSheetView: Bool
    @ObservedObject var notificationViewModel : NotificationViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(notificationViewModel.notificationArray, id: \.orderNumber) { item in
                    HStack {
                        Text(item.tableName)
                        Spacer()
                        Text(item.orderNumber.description)
                    }
                }.onDelete(perform: notificationViewModel.remove(at:))
            }
            .navigationBarTitle(Text("Notifications"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showSheetView = false
            }) {
                Text("Done").bold()
            })
        }
    }
}


struct ManageTablesView_Previews: PreviewProvider {
//    @ObservedObject static var diningRoom : DiningRoomViewModel = DiningRoomViewModel()
    
    static var previews: some View {
        DiningRoomView().environmentObject(DiningRoomViewModel())
    }
}

