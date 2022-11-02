//
//  SelectTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 15/10/2022.
//

import SwiftUI

struct SelectTableView: View {
    @Binding var currentTable : Int
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(currentTable)").font(.system(size: 70))
            Spacer()
            HStack {
                LazyVGrid(columns: columns) {
                    ForEach((1...9), id: \.self) { tableNumber in
                        FunctionBoxView(functionName: "\(tableNumber)") {
                            currentTable = tableNumber
                        }
                    }
                }
            }
        }
        
    }
}

struct SelectTableView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTableView(currentTable: .constant(1))
    }
}
