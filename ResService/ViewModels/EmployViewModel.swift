//
//  EmployModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/11/2022.
//

import Foundation
import Firebase
import FirebaseAuth

class EmployViewModel : ObservableObject {
    
    private var workersLocal : [User] = []
    @Published var workers : [User] = []
    
    init() {
        print("EmployViewModel - init")
        let ref = Database.database(url: dbURLConnection).reference().child(userCollectionName)
        ref.observe(DataEventType.value, with: { snapshot in
            guard let menu = snapshot.value as? [String: Any] else { print("exit"); return }
            for dish in menu {
                let json = dish.value as? [String : Any]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
                    let info = try JSONDecoder().decode(User.self, from: jsonData)
            
                    // only employee
//                    if info.role != "client" {
                        self.workersLocal.append(info)
//                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            self.workers = self.workersLocal
            self.workers = self.workers.sorted { u1, u2 in
                u1.UUID < u2.UUID
            }
            self.workersLocal = []
        })
    }
    
    func getOnlyEmployees() -> [User] {
        var us : [User] = []
        for worker in workers {
            if worker.role != "client" {
                us.append(worker)
            }
        }
        return us
    }
    
    func employ(email : String, role : RoleCategory) {
        for worker in workers {
            if worker.email == email {
                print(worker.authID)
                let ref = Database.database(url: dbURLConnection).reference().child(userCollectionName)
                ref.child(worker.authID).updateChildValues(["role" : role.rawValue])
                break
            }
        }
    }
    
    func removeWorker(at offset : IndexSet) {
        var test = self.getOnlyEmployees()

        let ids = offset.map({ test[$0].authID })
        print(ids)
        
        let ref = Database.database(url: dbURLConnection).reference().child(userCollectionName)
        ref.child(ids[0].description).updateChildValues(["role" : "client"])
        
        test.remove(atOffsets: offset)
    }
}
