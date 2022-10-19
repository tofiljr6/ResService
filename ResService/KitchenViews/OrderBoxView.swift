//
//  OrderBoxView.swift
//  ResService
//
//  Created by Mateusz Tofil on 18/10/2022.
//

import SwiftUI

struct OrderBoxView: View {
    var listOfNames : [String]
    
    var body: some View {
        VStack {
            ForEach(listOfNames, id: \.self) { item in
                HStack {
                    Text(item)
                    Spacer()
                }.padding()
                    .border(.purple)
            }
        }.background(.cyan)
    }
}

struct OrderBoxView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBoxView(listOfNames: ["classic", "kult", "vergan", "pommmes"])
    }
}
