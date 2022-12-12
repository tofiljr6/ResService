//
//  ConsumerMenuSingleCard2View.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/12/2022.
//

import SwiftUI
import FirebaseStorage

struct ConsumerMenuSingleCard2View: View {
    @EnvironmentObject var menuViewModel : MenuViewModel
    @Environment(\.colorScheme) var systemColorScheme
    var menu : Menu
    
    @State var retrivedImage : UIImage?
    
    var body: some View {
        VStack(alignment: .leading) {
            if retrivedImage == nil {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 340, height: 340)
                    .foregroundColor(.gray)
            } else {
                ZStack {
                    Image(uiImage: retrivedImage!)
                        .resizable()
                        .frame(width: 340, height: 340)
                        .scaledToFit()
                        .cornerRadius(5)
                    
                    if menu.armodel != "" {
                        Image(systemName: "camera.viewfinder")
                            .foregroundColor(.yellow)
                            .font(.title2)
                            .offset(x: 75, y: -75)
                    }
                    
                    if systemColorScheme == .light {
                        LinearGradient(gradient: Gradient(colors: [.white, .clear, .clear, .clear, .clear]), startPoint: .bottom, endPoint: .top)
                        Text(menu.dishName)
                            .foregroundColor(.black)
                            .font(.title)
                            .offset(x: -125, y: 150)
                    } else {
                        LinearGradient(gradient: Gradient(colors: [.black, .clear, .clear, .clear, .clear]), startPoint: .bottom, endPoint: .top)
                        Text(menu.dishName)
                            .foregroundColor(.white)
                            .font(.title)
                            .offset(x: -125, y: 150)
                    }
                }
            }
        }.onAppear { showDishPhoto() }
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
            ////        }
        } else {
            DispatchQueue.main.async {
                self.retrivedImage = menuViewModel.menuPhotos[menu.dishID]
            }
            //        }
        }
    }
}

struct ConsumerMenuSingleCard2View_Previews: PreviewProvider {
    static var menu : Menu = Menu(dishID: 1,
                           dishDescription: "Lorem ",
                           dishName: "Curry Wurst Classic",
                           dishPrice: 9.90,
                           dishProducts: "A, X, X",
                           dishOrderInMenu: 2,
                           dishCategory: "starter",
                           dishPhotoURL: UUID().uuidString,
                           armodel: "armodel")
    
    static var menuViewModel = MenuViewModel()
    
    
    static var previews: some View {
        ConsumerMenuSingleCard2View(menu: menu)
    }
}
