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
    @StateObject private var user = UserModel()
    @State private var showPopup : Bool = false
    
    var body: some View {
        if user.role == Role.waiter.rawValue {
            DiningRoomView(diningRoom: DiningRoomViewModel())
        } else if user.role == Role.boss.rawValue {
            BossMainView()
        } else if user.role == Role.client.rawValue {
            ConsumerMainView(userModel: user)
        }
        else {
            noUserRole
        }
    }
    
    var noUserRole : some View {
        // TODO: the view for client and another role in db
        VStack{
            Spacer()
            Image(systemName: "timelapse")
                .resizable()
                .frame(width: 250, height: 250)
                .scaledToFit()
            Spacer()
            Text("Hello \(user.username)!")
                .font(.title)
            Text("The views for your role: \(user.role)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}