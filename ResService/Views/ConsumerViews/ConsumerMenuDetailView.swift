//
//  ConsumerMenuDetailView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuDetailView: View {
    var dishDetail : Menu
    
    var body: some View {
        ScrollView {
            Image("currywurst")
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            HStack {
                Text(dishDetail.dishName)
                    .font(.title)
                Spacer()
                Text(dishDetail.dishPrice.description)
                    .font(.title)
                    .foregroundColor(.gray)
            }.padding()
            
            Divider()
            
            Text(dishDetail.dishCategory)
            
            Text(dishDetail.dishDescription)
                .padding()
                .multilineTextAlignment(.leading)
            
        }.ignoresSafeArea()
    }
}

struct ConsumerMenuDetailView_Previews: PreviewProvider {
    static var dishDetail : Menu = Menu(dishID: 1,
                                        dishDescription: "Pork chop flank short ribs bacon pastrami, tenderloin ribeye frankfurter jowl sausage. Short loin sirloin shoulder, brisket ham short ribs ground round pastrami bresaola prosciutto. Leberkas boudin ball tip pastrami, picanha meatloaf short ribs hamburger pig landjaeger pork loin salami sausage cupim kielbasa. Venison ground round beef sausage pastrami spare ribs, andouille pork belly kielbasa tri-tip ham swine fatback short loin tail. Buffalo capicola doner alcatra picanha jowl sirloin. Tri-tip chislic leberkas pastrami rump spare ribs. Jerky leberkas kielbasa, meatloaf venison frankfurter ribeye boudin pork chop salami doner landjaeger brisket.",
                                        dishName: "Curry Wurst",
                                        dishPrice: 4.90,
                                        dishProducts: "da",
                                        dishOrderInMenu: 1,
                                        dishCategory: "starter")
    
    static var previews: some View {
        ConsumerMenuDetailView(dishDetail: dishDetail)
    }
}
