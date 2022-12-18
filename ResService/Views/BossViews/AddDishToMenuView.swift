//
//  AddDishToMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 25/10/2022.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore // TODO: delete???

enum DishCategory : String, CaseIterable {
    case starter = "starter"
    case maincourse = "maincouse"
    case deserts = "deserts"
    case drinks = "drinks"
    case spirits = "spirits"
}

struct AddDishToMenuView: View {
    @StateObject var menuViewModel : MenuViewModel
    
    @State private var newDishName : String = ""
    @State private var newDishPrice : String = ""
    @State private var newDishDescription : String = ""
    @State private var newDishProducts : String = ""
    @State private var newDishCategory : DishCategory = DishCategory.deserts
    
    @State var selectedImage : UIImage?
    @State var isPickerShowing : Bool = false
    @State var retrivedImages = [UIImage]()
    
    @Environment(\.showingSheet) var showingSheet
    
    var body: some View {
        ScrollView {
            Text("Add new dish")
                .font(.title).bold()
            
            Spacer()
            
            
            VStack {
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .cornerRadius(5)
                }
//                else {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .frame(width: 250, height: 250)
//                        .cornerRadius(5)
//                        .scaledToFit()
//                }
                
                Button {
                    isPickerShowing = true
                } label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(5)
                            .frame(height: 50)
                        Text("Select a  photo")
                            .foregroundColor(.white)
                    }
                }
                
                Divider()
                
                HStack {
                    ForEach(retrivedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                }
                
                
            }.sheet(isPresented: $isPickerShowing) {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
            
            Group {
                TextField("Name", text: $newDishName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Price", text: $newDishPrice)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                
                TextField("Description", text: $newDishDescription)
                    .textFieldStyle(.roundedBorder)
                
                VStack {
                    Text("Select the type of dish for a new dish to be added to the menu")
                        .font(.callout).multilineTextAlignment(.leading)
                    
                    Picker("Pick a category of new dish", selection: $newDishCategory) {
                        ForEach(DishCategory.allCases, id: \.self) { item in
                            Text(item.rawValue)
                        }
                    }.pickerStyle(WheelPickerStyle())
                    .clipped()
                    .labelsHidden()
                }
            }
            
            Spacer()
            
            Button {
                if let price = Double(newDishPrice.replacingOccurrences(of: ",", with: ".")) {
                    let newDishPhotoUUID = UUID().uuidString
                    
                    // Save
                    menuViewModel.addNewDishToMenu(newDishName: newDishName,
                                                   newDishPrice: price,
                                                   newDishDescription: newDishDescription,
                                                   newDishProducts: newDishProducts,
                                                   newDishCategory: newDishCategory,
                                                   newDishPhotoURL: newDishPhotoUUID)
                    // Upload photo to FBStorage
                    uploadPhoto(fileNameWithoutExtension: newDishPhotoUUID)
                    
                    
                    
                    // Exit the view
                    self.showingSheet?.wrappedValue = false
                } else {
                    // error was occured
                    print("bład")
                }
            } label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(5)
                        .frame(height: 50)
                    Text("Save")
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }.padding()
    }
    
    func uploadPhoto(fileNameWithoutExtension: String) {
        guard selectedImage != nil else { return }
        let storageRef = Storage.storage().reference()
        
        // Data in memory
        let imageData = selectedImage!.jpegData(compressionQuality: 0.05) // 0.8
        guard imageData != nil else { return }
        
        let path = "imagesOfDishes/\(fileNameWithoutExtension).jpg"
        
        let fileRef = storageRef.child(path)
        
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil { }
        }
    }
    
    func showPhotoFromStorageFB(photoURL : String) { // only for testing
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("imagesOfDishes/\(photoURL).jpg")
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        self.retrivedImages.append(image)
                    }
                }
            }
        }
    }
}

struct AddDishToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let menuViewModel : MenuViewModel = MenuViewModel()
        AddDishToMenuView(menuViewModel: menuViewModel)
    }
}
