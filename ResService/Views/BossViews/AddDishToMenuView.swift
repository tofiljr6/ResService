//
//  AddDishToMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 25/10/2022.
//

import SwiftUI
import Firebase

struct AddDishToMenuView: View {
    @StateObject var menuViewModel : MenuViewModel
    
    @State private var newDishName : String = ""
    @State private var newDishPrice : String = ""
    @State private var newDishDescription : String = ""
    @State private var newDishProducts : String = ""
    
    @Environment(\.showingSheet) var showingSheet
    
    var body: some View {
        ScrollView {
            Text("Add new dish")
                .font(.title).bold()
            
            Spacer()
            
            ZStack {
                Circle()
                
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 200, height: 150)
                    .scaledToFit()
                    .foregroundColor(.blue)
            }.padding()
            
            Group {
                TextField("Name", text: $newDishName)
                    .textFieldStyle(.plain)
                
                TextField("Price", text: $newDishPrice)
                    .textFieldStyle(.plain)
                    .keyboardType(.decimalPad)
                
                TextField("Description", text: $newDishDescription)
                    .textFieldStyle(.plain)
                    .frame(height: 120)
                
                TextField("Products inside", text: $newDishProducts)
                    .textFieldStyle(.plain)
                    .frame(height: 120)
            }.padding().border(.blue)
            
            Spacer()
            
            Button {
                // Save
                menuViewModel.addNewDishToMenu(newDishName: newDishName, newDishPrice: Double(newDishPrice)!, newDishDescription: newDishDescription, newDishProducts: newDishProducts)
                
                // Exit the view
                self.showingSheet?.wrappedValue = false
            } label: {
                Text("Save")
                    .bold()
                    .frame(width: 200, height: 40)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top)
            }
            
            Spacer()
        }.padding()
    }
}

struct AddDishToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let menuViewModel : MenuViewModel = MenuViewModel()
        AddDishToMenuView(menuViewModel: menuViewModel)
    }
}
