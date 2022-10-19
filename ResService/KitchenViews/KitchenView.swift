//
//  KitchenView.swift
//  ResService
//
//  Created by Mateusz Tofil on 13/10/2022.
//

import SwiftUI

struct KitchenView: View {
    @ObservedObject var progress : OrdersInProgress
    
    var body: some View {
        ForEach(Array(self.progress.getDishesToTisch(number: 1)), id: \.self) { key in
            HStack{
                Text(key.dishName)
                Spacer()
                Text("\(key.dishAmount)")
            }.padding()
        }
    }
}

struct KitchenView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenView(progress: OrdersInProgress())
    }
}
