//
//  AddNewWorkerView.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/11/2022.
//

import SwiftUI

enum RoleCategory : String, CaseIterable {
    case boss = "boss"
    case waiter = "waiter"
    case kitchen = "kitchen"
    case client = "client"
}

struct AddNewWorkerView: View {
    @EnvironmentObject var employViewModel : EmployViewModel
    @State private var email : String = ""
    @State private var role : RoleCategory = RoleCategory.waiter
    
    var body: some View {
        VStack() {
            HStack {
                Text("Add new employee")
                    .font(.title)
                    .bold()
//                    .offset(y: -45)
                Spacer()
            }
            
            HStack {
                Text("To add a new employee to your team you must enter their exact email address. Then, set what role the newly added employee is to play.")
                    .font(.callout).multilineTextAlignment(.leading)
            }
            
            
            HStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Picker("Pick a category of new dish", selection: $role) {
                ForEach(RoleCategory.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }.pickerStyle(WheelPickerStyle())
            
            Button {
                employViewModel.employ(email: email, role: role)
            } label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(5)
                        .frame(height: 50)
                    Text("Add")
                        .foregroundColor(.white)
                }
            }

            
            
        }.navigationTitle("Employ")
            .padding()
    }
}

struct AddNewWorkerView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background")
            .sheet(isPresented: .constant(true)) {
                AddNewWorkerView().environmentObject(EmployViewModel()).presentationDetents([.fraction(0.70)])
            }
    }
}
