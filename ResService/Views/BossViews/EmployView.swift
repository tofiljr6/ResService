//
//  EmployView.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/11/2022.
//

import SwiftUI
import FirebaseAuth

struct EmployView: View {
    @StateObject var employViewModel : EmployViewModel = EmployViewModel()
    @State private var email : String = ""
    @State private var workerDetailsIsShowing : Bool = false
    
    var body: some View {
        VStack{
            List {
                ForEach(employViewModel.getOnlyEmployees(), id: \.UUID) { item in 
                    NavigationLink(destination: EmployeeDetailView(user: item).environmentObject(employViewModel)) {
                        HStack {
                            Text(item.username)
                            Spacer()
                            Text(item.role).foregroundColor(.gray)
                        }
                    }
                }.onDelete(perform: employViewModel.removeWorker(at:))
            }
        }.navigationTitle("Team")
        .toolbar {
            Button {
                // add a new worker to your team
                workerDetailsIsShowing.toggle()
            } label: {
                Image(systemName: "person.fill.badge.plus").foregroundColor(.green)
            }
        }.sheet(isPresented: $workerDetailsIsShowing) {
            AddNewWorkerView().environmentObject(employViewModel).presentationDetents([.fraction(0.70)])
        }
    }
}




struct EmployView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            EmployView()
        }
    }
}
