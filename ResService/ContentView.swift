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
    @StateObject var progress = OrdersInProgress()
    @StateObject var SO_orderInKitchen = OrdersInKitchen()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Restaurant Serivce")
                    .font(.title)
                
                Spacer()
                
                VStack {
                    Spacer()
                    Text("3 orders").padding(.top).foregroundColor(.green)
                    Text("37 min").padding().foregroundColor(.yellow)
                    Text("12 Tables").padding(.bottom).foregroundColor(.red)
                    Spacer()
                }.font(.system(size: 35))
    
                Spacer()
                
                HStack {
                    Spacer()
                    NavigationLink(destination: WaiterOrderView(progress: progress, OO_orderInKitchen: SO_orderInKitchen)) {
                        Text("iPhone")
                        Image(systemName: "iphone")
                    }
                    Spacer()
                    NavigationLink(destination: KitchenView(progress: progress, OO_orderInKitchen: SO_orderInKitchen)) {
                        Text("iPad")
                        Image(systemName: "ipad")
                    }
                    Spacer()
                }
            }
        }.navigationTitle("title")
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
