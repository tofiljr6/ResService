//
//  DishView.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/10/2022.
//

import SwiftUI

struct DishView: View {
    var dishName : String
    var clicked: (() -> Void)
    
    var body: some View {
        Button(action: clicked) {
            ZStack{
                Rectangle()
                    .fill(.red)
                    .frame(width: 125, height: 125)
                    .cornerRadius(15)
                Text(dishName)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .frame(width: 115)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct DishView_Previews: PreviewProvider {
    static var previews: some View {
        DishView(dishName: "Classic Curry Wurst") {
            print("clicked")
        }
    }
}
