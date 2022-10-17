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
                    .cornerRadius(15)
                    .padding(0)
                Text(dishName)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }.frame(width: 125, height: 125)
        }
    }
}

struct DishView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                DishView(dishName: "Classic Curry Wurst") {
                    print("clicked")
                }
                DishView(dishName: "Classic Curry Wurst") {
                    print("clicked")
                }
            }
            DishView(dishName: "Classic Curry Wurst") {
                print("clicked")
            }
        }
    }
}
