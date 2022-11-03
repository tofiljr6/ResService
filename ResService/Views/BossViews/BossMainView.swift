//
//  BossMainView.swift
//  ResService
//
//  Created by Mateusz Tofil on 25/10/2022.
//

import SwiftUI



struct BossMainView: View {
    var sections : [MenuSection] = [MenuSection(id: UUID(), name: "Role", items: [MenuItem(id: UUID(), name: "Preview Waiter"),
                                                                                  MenuItem(id: UUID(), name: "Preview Kitchen")]),
                                    MenuSection(id: UUID(), name: "Manage restauratn", items: [MenuItem(id: UUID(), name: "Add new dishes"),
                                                                                               MenuItem(id: UUID(), name: "Employee new"),
                                                                                               MenuItem(id: UUID(), name: "Manage tables")])]
    
    private enum BossSection : String {
        case previewWaiter  = "Preview Waiter"
        case previewKitchen = "Preview Kitchen"
        case addNewDishes   = "Add new dishes"
        case manageTables   = "Manage tables"
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sections, id: \.id) { section in
                    Section(header: Text(section.name)) {
                        ForEach(section.items, id: \.id) { item in
                            NavigationLink(destination: self.getDestination(itemText: item.name)) {
                                Text(item.name)
                            }
                        }
                    }
                }
            }.navigationTitle("Restaurant settings")
        }
    }
    
    private func getDestination(itemText: String) -> AnyView {
        let val = BossSection(rawValue: itemText)
        
        switch val {
        case .some(.previewKitchen): return AnyView(KitchenView().navigationBarTitleDisplayMode(.inline))
        case .some(.previewWaiter): return AnyView(WaiterOrderView().navigationBarTitleDisplayMode(.inline))
        case .some(.addNewDishes): return AnyView(MenuView())
        case .some(.manageTables): return AnyView(ManageTablesView().navigationBarTitleDisplayMode(.inline))
        case .none:
            return AnyView(Text("Nieznazny bład"))
            
        }
    }
}

struct BossMainView_Previews: PreviewProvider {
    static var previews: some View {
        BossMainView()
    }
}
