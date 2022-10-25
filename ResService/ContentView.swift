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
    @StateObject private var SO_user = UserModel()
    @StateObject private var progress = OrdersInProgress()
    @StateObject private var SO_orderInKitchen = OrdersInKitchen()
    @State private var showPopup : Bool = false
    
    var body: some View {
        if SO_user.role == Role.waiter.rawValue {
            VStack {
                NavigationView {
//                    NavigationLink(destination: WaiterOrderView(progress: progress, OO_orderInKitchen: SO_orderInKitchen)) {
                    NavigationLink(destination: WaiterOrderView()) {
                        Text("iPhone")
                        Image(systemName: "iphone")
                    }
                    .navigationTitle("Waiter")
                    .toolbar {
                        Button(action: { showPopup.toggle() }, label:  { Image(systemName: "eye.circle") } )
                    }.sheet(isPresented: $showPopup) {
                        KitchenView(progress: self.progress, OO_orderInKitchen: SO_orderInKitchen)
                    }
                }
            }
        } else if SO_user.role == Role.boss.rawValue {
            BossMainView()
        }
        else {
            // TODO: the view for client and another role in db
            VStack{
                Spacer()
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .scaledToFit()
                Spacer()
                Text("Hello \(SO_user.username)!")
                    .font(.title)
                Text("The views for your role: \(SO_user.role)")
            }
        }
    }
}

func firedata() {
    let ref = Database.database(url: "https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("testCollection")
    
    ref.child("setter").getData(completion:  { error, snapshot in
        guard error == nil else {
            print(error!.localizedDescription)
            return;
        }
        presentValue = snapshot?.value as? String ?? "Unknown";
    });
    
    print(presentValue)
    
    ref.child("getter").setValue("100")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
