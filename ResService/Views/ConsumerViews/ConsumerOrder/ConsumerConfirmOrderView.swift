//
//  ConsumerConfirmOrderView.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import SwiftUI

struct ConsumerConfirmOrderView: View {
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuModel : MenuViewModel
    @EnvironmentObject var diningRoomModel : DiningRoomViewModel
    @StateObject var orderInKitchen : OrdersInKitchenViewModel = OrdersInKitchenViewModel()
    @StateObject var locationManager = LocationManager()
    @Binding var shouldPopToRootView : Bool
    @Binding var tableID : Int
    @ObservedObject var userOrderModel : UserOrderModel
    @State var showSuccesfulResult : Bool = false
    @State var showFailResult : Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(userOrderModel.listofOrder.sorted(by: >), id: \.key) { key, value in
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
//                Text("Restaurant location: \(restaurantLocationManager.restaurantCoordinates.latitude), \(restaurantLocationManager.restaurantCoordinates.longitude)")
            }
            
            confirmButton
        }.navigationTitle("Payment")
    }
    
    var confirmButton : some View {
        Button {
            // checking localization
            locationManager.requestLocation()
            print("Your location: \(locationManager.location!.latitude), \(locationManager.location!.longitude)")

            // set variable to see dedicatet alert
            if locationManager.authUserLocationWithRestaurant() {
                showSuccesfulResult = true
            } else {
                showFailResult = true
            }
        } label: {
            ZStack {
                Rectangle()
                    .cornerRadius(8)
                    .foregroundColor(.green)
                    .frame(height: 50)
                    .padding()
                Text("Pay")
                    .foregroundColor(.white)
                    .font(Font.body.bold())
            }
        }.alert("Thanks! Your order has been sent correctly", isPresented: $showSuccesfulResult) {
            Button("OK", role: .cancel) {
                // return to the main customer view
                self.shouldPopToRootView = false
                // send order to the kitchne
                self.orderInKitchen.addOrder(tableNumber: tableID, currentOrder: menuModel.convertIntDict(dict: userOrderModel.listofOrder))
                
                // occupy table
                self.diningRoomModel.setTableStatus(number: tableID, color: "red")
                
                // check
                print("\(userModel.username) ordered \(userOrderModel.listofOrder)")
            }
        }.alert("Ohhh no! Your and the restaurant location are not similar", isPresented: $showFailResult) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct ConsumerConfirmOrderView_Previews: PreviewProvider {
    @State static var shouldPopToRootView : Bool = false
    @State static var tableID : Int = 41
    static var userOrderModel : UserOrderModel = UserOrderModel()

    static var previews: some View {
        NavigationView {
            ConsumerConfirmOrderView(shouldPopToRootView: $shouldPopToRootView, tableID: $tableID, userOrderModel: userOrderModel)
                .navigationTitle("Confirmation")
        }
    }
}
