//
//  FunctionBoxView.swift
//  ResService
//
//  Created by Mateusz Tofil on 13/10/2022.
//

import SwiftUI

struct FunctionBoxView: View {
    var functionName : String
    var clicked: (() -> Void)
    
    var body: some View {
        Button(action: clicked) {
            ZStack{
                Rectangle()
                    .fill(.blue)
                    .frame(width: 75, height: 75)
                    .cornerRadius(15)
                Text(functionName)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .frame(width: 70)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct FunctionBoxView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            FunctionBoxView(functionName: "Pay") {
                print("clicked")
            }
            FunctionBoxView(functionName: "Order") {
                print("clicked")
            }
        }
    }
}
