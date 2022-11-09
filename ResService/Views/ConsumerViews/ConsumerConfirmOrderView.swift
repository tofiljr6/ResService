//
//  ConsumerConfirmOrderView.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import SwiftUI

struct ConsumerConfirmOrderView: View {
//    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    @EnvironmentObject var diningRoomModel : DiningRoomViewModel
    @StateObject var orderInKitchen : OrdersInKitchenViewModel = OrdersInKitchenViewModel()
    @StateObject var locationManager = LocationManager()
    @Binding var shouldPopToRootView : Bool
    @Binding var tableID : Int
    @State var showSuccesfulResult : Bool = false
    @State var showFailResult : Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(userModel.listofOrder.sorted(by: >), id: \.key) { key, value in
                    HStack {
                        Text(menuModel.getMenuByID(id: key)!.dishName)
                        Spacer()
                        Text("\(value.description) x \(String(format: "%.2f", menuModel.getMenuByID(id: key)!.dishPrice))")
                    }
                }
            }
            
            if locationManager.authUserLocationWithRestaurant() {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .foregroundColor(.green).font(.title)
            } else {
                Image(systemName: "person.crop.circle.badge.xmark")
                    .foregroundColor(.red).font(.title)
            }

            if let location = locationManager.location {
                Text("Your location: \(location.latitude), \(location.longitude)")
                Text("Restaurant location: \(locationManager.restaurantLocation!.latitude), \(locationManager.restaurantLocation!.longitude)")
            }
            
            confirmButton
        }.navigationTitle("Payment")
    }
    
    var confirmButton : some View {
        Button("Confirm") {
            // sprawdzenie lokalizacji
            locationManager.requestLocation()
            print("Your location: \(locationManager.location!.latitude), \(locationManager.location!.longitude)")

            if locationManager.authUserLocationWithRestaurant() {
                showSuccesfulResult = true
            } else {
                showFailResult = true
            }
        }.alert("Thanks! Your order has been sent correctly", isPresented: $showSuccesfulResult) {
            Button("OK", role: .cancel) {
                // return to the main customer view
                self.shouldPopToRootView = false
                self.orderInKitchen.addOrder(tableNumber: tableID, currentOrder: menuModel.convertIntDict(dict: userModel.listofOrder))
            }
        }.alert("Ohhh no! Your and the restaurant location are not similar", isPresented: $showFailResult) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct ConsumerConfirmOrderView_Previews: PreviewProvider {
    @State static var shouldPopToRootView : Bool = false
    @State static var tableID : Int = 41
    
    static var previews: some View {
        NavigationView {
            ConsumerConfirmOrderView(shouldPopToRootView: $shouldPopToRootView, tableID: $tableID)
                .navigationTitle("Confirmation")
        }
    }
}
