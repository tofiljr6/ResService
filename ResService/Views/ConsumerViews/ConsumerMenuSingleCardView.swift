//
//  MenuSingleCardView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuSingleCardView: View {
    var menu : Menu
    
    var cardWidth  : CGFloat = 200
    var cardHeight : CGFloat = 240
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 200, height: 200)
            HStack {
                Text(menu.dishName)
                Spacer()
                Text(menu.dishPrice.description)
            }.foregroundColor(.primary)
        }.padding(.leading, 15)
    }
}

struct MenuSingleCardView_Previews: PreviewProvider {
    static var menu : Menu = Menu(dishID: 1,
                           dishDescription: "Lorem ",
                           dishName: "Curry Wurst Classic",
                           dishPrice: 9.90,
                           dishProducts: "A, X, X",
                           dishOrderInMenu: 2,
                           dishCategory: "starter")
    
    static var previews: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(0..<3) {_ in
                    ConsumerMenuSingleCardView(menu: menu)
                }
            }
        }.padding(.leading)
    }
}
