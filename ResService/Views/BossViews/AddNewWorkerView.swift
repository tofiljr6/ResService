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
        VStack(spacing: 20) {
            
            
            HStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Find") {
                    // search
                }
            }
            
            Text("To add a new employee to your team you must enter their exact email address.")
                .font(.caption).multilineTextAlignment(.leading)
            
            Picker("Pick a category of new dish", selection: $role) {
                ForEach(RoleCategory.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }.pickerStyle(.menu)
            
            Text("Set what role the newly added employee is to play")
                .font(.caption).multilineTextAlignment(.leading)
            
            Button("Add") {
                print("click")
                employViewModel.employ(email: email, role: role)
            }
            
            
        }.navigationTitle("Employ")
            .padding()
    }
}

struct AddNewWorkerView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewWorkerView().environmentObject(EmployViewModel())
    }
}
