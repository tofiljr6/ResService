//
//  ContentView.swift
//  ResService
//
//  Created by Mateusz Tofil on 11/10/2022.
//

import SwiftUI
import Firebase

var conter = 0
var presentValue : String = "50"

struct ContentView: View {
    @StateObject var user : UserModel = UserModel()
    @State private var showPopup : Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isRefresh : Bool = false
    
    var body: some View {
        if user.role == Role.waiter.rawValue {
            DiningRoomView().environmentObject(user)
                .environmentObject(MenuViewModel())
                .environmentObject(OrdersInProgressViewModel())
                .environmentObject(OrdersInKitchenViewModel())
                .environmentObject(NotificationViewModel())
        } else if user.role == Role.boss.rawValue {
            BossMainView().environmentObject(user)
                .environmentObject(NotificationViewModel())
        } else if user.role == Role.client.rawValue {
            ConsumerMainView().environmentObject(MenuViewModel()).environmentObject(user)
        } else if user.role == Role.kitchen.rawValue {
            KitchenView()
                .environmentObject(OrdersInProgressViewModel())
                .environmentObject(OrdersInKitchenViewModel())
                .environmentObject(user)
                .environmentObject(NotificationViewModel())
        } else if user.role == "Unknown" {
            noUserInDB
        }
        else {
            noUserRole.onAppear(perform: {
                user.initUser()
            })
        }
    }
    
    var noUserInDB : some View {
        HStack{
            VStack {
                Text("A user does not exist in database")
            }

            Button {
                UserDefaults.standard.removeObject(forKey: "userUIDey")
            } label: {
                ZStack {
                    Text("Back")
                }.padding(.horizontal)
            }
        }
    }
    
    var noUserRole : some View {
        VStack{
            Spacer()
            Image(systemName: "network")
                .resizable()
                .frame(width: 50, height: 50)
                .scaledToFit()
                .foregroundColor(.gray)
            
            Text("Establishing a connection to the database")
            
            if isRefresh == true {
                Text("Close the application and restart it")
            }
            Spacer()
            
            Button {
                UserDefaults.standard.removeObject(forKey: "userUIDey")
                isRefresh = true
            } label: {
                ZStack {
                    Text("Refresh")
                }.padding(.horizontal)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserModel())
    }
}
