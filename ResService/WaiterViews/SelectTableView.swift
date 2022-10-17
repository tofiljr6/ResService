//
//  SelectTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 15/10/2022.
//

import SwiftUI

struct SelectTableView: View {
    @Binding var currentTable : Int
    var body: some View {
        VStack {
            Spacer()
            Text("\(currentTable)").font(.system(size: 70))
            Spacer()
            HStack {
                Spacer()
                FunctionBoxView(functionName: "1") {
                    currentTable = 1
                }
                Spacer()
                FunctionBoxView(functionName: "2") {
                    currentTable = 2
                }
                Spacer()
            }
        }
        
    }
}

struct SelectTableView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTableView(currentTable: .constant(1))
    }
}
