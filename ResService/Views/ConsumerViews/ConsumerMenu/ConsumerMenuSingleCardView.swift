//
//  MenuSingleCardView.swift
//  ResService
//
//  Created by Mateusz Tofil on 06/11/2022.
//

import SwiftUI
import FirebaseStorage

struct ConsumerMenuSingleCardView: View {
    @EnvironmentObject var menuViewModel : MenuViewModel
    var menu : Menu
    
    @State var retrivedImage : UIImage?
    
    var cardWidth  : CGFloat = 200
    var cardHeight : CGFloat = 240
    
    var body: some View {
        VStack(alignment: .leading) {
            if retrivedImage == nil {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)
            } else {
                Image(uiImage: retrivedImage!)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(5)
                    
            }
            HStack {
                Text(menu.dishName)
                Spacer()
                Text(menu.dishPrice.description)
            }.foregroundColor(.primary)
        }
        .padding(.leading, 15)
        .onAppear {
            showDishPhoto()
        }
    }
    
    func showDishPhoto() {
        if menuViewModel.menuPhotos[menu.dishID] == nil {
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child("imagesOfDishes/\(menu.dishPhotoURL).jpg")
            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error == nil && data != nil {
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            print("załadowano menunr \(menu.dishID)")
                            self.retrivedImage = image
                        }
                    }
                }
            }
//        }
        } else {
            DispatchQueue.main.async {
                self.retrivedImage = menuViewModel.menuPhotos[menu.dishID]
            }
        }
    }
}

struct MenuSingleCardView_Previews: PreviewProvider {
    static var menu : Menu = Menu(dishID: 1,
                           dishDescription: "Lorem ",
                           dishName: "Curry Wurst Classic",
                           dishPrice: 9.90,
                           dishProducts: "A, X, X",
                           dishOrderInMenu: 2,
                           dishCategory: "starter",
                           dishPhotoURL: UUID().uuidString)
    
    static var menuViewModel = MenuViewModel()
    
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
