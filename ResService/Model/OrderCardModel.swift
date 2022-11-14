//
//  OrderCardView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import Foundation

struct OrderCard : Hashable, Identifiable {
    var id: UUID
    
    static func == (lhs: OrderCard, rhs: OrderCard) -> Bool {
        lhs.info.table < rhs.info.table
    }
    
    let info : Order
    let dishes : [Dish]
}
