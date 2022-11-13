//
//  EmployeeDetailView.swift
//  ResService
//
//  Created by Mateusz Tofil on 13/11/2022.
//

import SwiftUI

struct EmployeeDetailView: View {
    @EnvironmentObject var employViewModel : EmployViewModel
    @State private var role : RoleCategory = RoleCategory.waiter
    @State var user : User
    
    var body: some View {
        VStack {
            Picker("Pick a category of new dish", selection: $role) {
                ForEach(RoleCategory.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }.pickerStyle(.menu)
            
            Button("Save") {
                employViewModel.employ(email: user.email, role: role)
            }

        }.navigationTitle(user.username.description)
    }
}

struct EmployeeDetailView_Previews: PreviewProvider {
    static var user : User = User(role: "client", username: "username", email: "x@gmail.com", UUID: UUID().uuidString, authID: UUID().uuidString)
    
    static var previews: some View {
        EmployeeDetailView(user: user)
    }
}
