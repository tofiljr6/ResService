//
//  OrderView.swift
//  ResService
//
//  Created by Mateusz Tofil on 17/10/2022.
//

import SwiftUI

struct OrderView: View {
    var dishes : [String]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct OrderView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        OrderView(dishes: ["classic", "kult", "pommes"])
    }
}
