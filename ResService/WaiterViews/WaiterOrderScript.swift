//
//  WaiterOrderScript.swift
//  ResService
//
//  Created by Mateusz Tofil on 17/10/2022.
//

import Foundation
import Firebase

func sendSingleOrder(tablesNumber: Int) {
    let ref = Database.database(url: dbURLConnection).reference().child(ordersCollectionName)
    var dishStructs = [dish]()

    ref.child("table\(tablesNumber)").child("dishes").getData(completion:  { error, snapshot in
        guard error == nil else {
            print(error!.localizedDescription)
            return;
        }
        
        // get the data from collectionName into dict
        let alreadyOrdered =  snapshot?.value as? NSDictionary ?? [:]
        
        for key in alreadyOrdered.allKeys {
            if let x = currentOrder[key as! String] {
                if let y = alreadyOrdered.value(forKey: key as! String) as? Int {
                    currentOrder.updateValue(x+y, forKey: key as! String )
                }
            }
        }
        
        for i in currentOrder {
            dishStructs.append(dish.init(name: i.key, amount: i.value))
        }
        
        if !dishStructs.isEmpty {
            for i in 0...dishStructs.count-1 {
                ref.child("table\(tablesNumber)").child("dishes").child(dishStructs[i].name).setValue(dishStructs[i].amount)
            }
        }
        currentOrder.removeAll()
    });
}
