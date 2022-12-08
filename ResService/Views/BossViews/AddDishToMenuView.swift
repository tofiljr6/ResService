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
    @State private var newDishCategory : DishCategory = DishCategory.starter
    
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
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .scaledToFit()
                }
                
                Button {
                    isPickerShowing = true
                } label: {
                    Text("Select a  photo")
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
                Picker("Pick a category of new dish", selection: $newDishCategory) {
                    ForEach(DishCategory.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                
                TextField("Name", text: $newDishName)
                    .textFieldStyle(.plain)
                
                TextField("Price", text: $newDishPrice)
                    .textFieldStyle(.plain)
                    .keyboardType(.decimalPad)
                
                TextField("Description", text: $newDishDescription)
                    .textFieldStyle(.plain)
                    .frame(height: 120)
                
                TextField("Products inside", text: $newDishProducts)
                    .textFieldStyle(.plain)
                    .frame(height: 120)
            }.padding().border(.blue)
            
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
                Text("Save")
                    .bold()
                    .frame(width: 200, height: 40)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top)
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
