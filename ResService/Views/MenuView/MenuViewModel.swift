//
//  MenuViewModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 26/10/2022.
//

import Foundation
import Firebase

final class MenuViewModel : ObservableObject {
    private let menuCollectionName = "menuCollection"
    private let paramCollectionName = "param"
    private var menuUniqueName = "menuUniqueID"
    private let dbURLConnection = "https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/"
    
    private var uniqueNewDishID : Int = -1
    private var menuDishhesLocal: [Menu] = []
    
    @Published var menuDishes: [Menu] = []

    init() {
        print("MenuViewModel is initialized")
        
        // load unique param to new dish
        let paramref = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        paramref.observe(DataEventType.value, with: { snaphot in
            guard let paramsinfo = snaphot.value as? [String: Int] else { return }
            if paramsinfo[self.menuUniqueName] != nil {
                self.uniqueNewDishID = paramsinfo[self.menuUniqueName]!
            }
        })
        
        // load menus dishes to array
        let ref = Database.database(url: dbURLConnection).reference().child(menuCollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
//            print("nowe danie w bazie, pobieram!")
            guard let menu = snapshot.value as? [String: Any] else { print("exit"); return }
            for dish in menu {
                let json = dish.value as? [String : Any]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
                    let info = try JSONDecoder().decode(Menu.self, from: jsonData)
                    self.menuDishhesLocal.append(info)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        
            // sorted local array according by dishID
            self.sortedById() // TODO: the boss should decide where dish box is placed
            
            self.menuDishes = self.menuDishhesLocal
            self.menuDishhesLocal = []
        })
    }
    
    private func sortedById() -> Void {
        self.menuDishhesLocal = self.menuDishhesLocal.sorted(by: { m1, m2 in
            return m1.dishOrderInMenu < m2.dishOrderInMenu
        })
    }
    
    func addNewDishToMenu(newDishName : String, newDishPrice : String, newDishDescription : String, newDishProducts : String) -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(menuCollectionName)
        
        let newDish = [
            "dishID" : self.uniqueNewDishID.description,
            "dishName" : newDishName,
            "dishPrice" : newDishPrice,
            "dishDescription" : newDishDescription,
            "dishProducts" : newDishProducts,
            "dishOrderInMenu" : self.uniqueNewDishID.description
        ] as [String : String]
        
        ref.child("dishmenu\(self.uniqueNewDishID.description)").setValue(newDish)
        
        // update value in params
        incrementUniqueID()
    }
    
    func setNewOrderInMenu() -> Void {
        let ref = Database.database(url: dbURLConnection).reference().child(menuCollectionName)
        var i = 0
        for menu in menuDishes {
            ref.child("dishmenu\(menu.dishID)").updateChildValues(["dishOrderInMenu" : i.description])
            i += 1
        }
    }
    
    private func incrementUniqueID() {
        let paramref = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        paramref.child(self.menuUniqueName).setValue(self.uniqueNewDishID + 1)
    }
}
