//
//  AddDishesView.swift
//  ResService
//
//  Created by Mateusz Tofil on 25/10/2022.
//

import SwiftUI

struct MenuView: View {
    @StateObject var menuViewModel = MenuViewModel()
    @State private var showPopup : Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(menuViewModel.menuDishes, id: \.dishID) { dish in
                    HStack {
                        Text(dish.dishID).foregroundColor(.gray)                
                        Text(dish.dishName)
                    }
                }
            }.navigationBarTitle("Menu", displayMode: .inline)
            .toolbar {
                Button(action: { showPopup.toggle() }, label: { Image(systemName: "plus.circle") })
            }.sheet(isPresented: $showPopup) {
                AddDishToMenuView(menuViewModel: menuViewModel).environment(\.showingSheet, self.$showPopup)
            }
        }
    }
}

struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}

struct AddDishesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuView()
        }
    }
}
