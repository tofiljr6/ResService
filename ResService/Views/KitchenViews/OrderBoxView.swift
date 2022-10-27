//
//  OrderBoxView.swift
//  ResService
//
//  Created by Mateusz Tofil on 18/10/2022.
//

import SwiftUI

struct OrderBoxView: View {
    var tableNumber : Int
    var listOfNames : [String]
    
    var body: some View {
        VStack{
            ForEach(listOfNames, id: \.self) {
                Text($0)
                
            }
        }
    }
}

struct OrderBoxView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBoxView(tableNumber: 1, listOfNames: ["classic", "kult", "vergan", "pommmes"])
    }
}
