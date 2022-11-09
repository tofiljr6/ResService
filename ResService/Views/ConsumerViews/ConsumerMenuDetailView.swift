//
//  ConsumerMenuDetailView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI

struct ConsumerMenuDetailView: View {
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var menuViewModel : MenuViewModel
    
    @State var dishAmount : Int = 0
    
    var dishDetail : Menu
        
    var body: some View {
        ScrollView {
            if menuViewModel.menuPhotos[dishDetail.dishID] != nil {
                Image(uiImage: menuViewModel.menuPhotos[dishDetail.dishID]!)
                    .resizable()
                    .frame(height: 250)
                    .scaledToFit()
            } else {
                Image(systemName: "xmark.octagon.fill")
                    .resizable()
                    .frame(height: 250)
                    .scaledToFit()
            }
            
            Spacer()
            
            HStack {
                Text(dishDetail.dishName)
                    .font(.title)
                Spacer()
                Text(dishDetail.dishPrice.description)
                    .font(.title)
                    .foregroundColor(.gray)
            }.padding()
            
            HStack {
                Button(action: {
                    // decresae dishes amount in order
                    dishAmount -= 1
                    userModel.addToOrder(menu: dishDetail.dishID, amount: dishAmount)
                    if dishAmount <= 0 {
                        dishAmount = 0
                        userModel.deleteOrder(menu: dishDetail.dishID)
                    }
                }){ Image(systemName: "minus.circle").font(.title) }
                
                // display current amount of dishes
                Text(userModel.getAmountToOrder(menu: dishDetail.dishID).description)
                
                Button(action: {
                    // increase dishes amount in order
                    dishAmount += 1
                    userModel.addToOrder(menu: dishDetail.dishID, amount: dishAmount)
                }){ Image(systemName: "plus.circle").font(.title) }
            }
            
            Divider()
            
            Text(dishDetail.dishCategory)
            
            Text(dishDetail.dishDescription)
                .padding()
                .multilineTextAlignment(.leading)
            
        }
    }
}

struct ConsumerMenuDetailView_Previews: PreviewProvider {
    static var dishDetail : Menu = Menu(dishID: 1,
                                        dishDescription: "Pork chop flank short ribs bacon pastrami, tenderloin ribeye frankfurter jowl sausage. Short loin sirloin shoulder, brisket ham short ribs ground round pastrami bresaola prosciutto. Leberkas boudin ball tip pastrami, picanha meatloaf short ribs hamburger pig landjaeger pork loin salami sausage cupim kielbasa. Venison ground round beef sausage pastrami spare ribs, andouille pork belly kielbasa tri-tip ham swine fatback short loin tail. Buffalo capicola doner alcatra picanha jowl sirloin. Tri-tip chislic leberkas pastrami rump spare ribs. Jerky leberkas kielbasa, meatloaf venison frankfurter ribeye boudin pork chop salami doner landjaeger brisket.",
                                        dishName: "Curry Wurst",
                                        dishPrice: 4.90,
                                        dishProducts: "da",
                                        dishOrderInMenu: 1,
                                        dishCategory: "starter",
                                        dishPhotoURL: UUID().uuidString)
    static var menuViewModel : MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        ConsumerMenuDetailView(dishDetail: dishDetail)
    }
}
