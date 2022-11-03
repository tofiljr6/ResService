//
//  ManageTableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct ManageTablesView: View {
    @ObservedObject var manageTable : ManageTablesViewModel
    @State var manageTableViewWidth  = UIScreen.main.bounds.width * 0.8
    @State var manageTableViewHeight = UIScreen.main.bounds.height * 0.8
    @State var editMode : Bool = false
    @State var editModeInfo : String = "Edit"
    
    init() {
        self.manageTable = ManageTablesViewModel()
    }
        
    var body: some View {
        ZStack {
            ForEach(manageTable.tablesInfo, id: \.id) { item in
                TableView(id: item.id, color: item.color, location: item.location,
                          manageTableViewWidth: $manageTableViewWidth,
                          manageTableViewHeight: $manageTableViewHeight,
                          editMode: $editMode, manageTable: manageTable)
            }
        }
        .frame(width: manageTableViewWidth, height: manageTableViewHeight)
        .border(.red)
        .toolbar {
            HStack {
                Button(editModeInfo) {
                    editModeText()
                }
                
                Button(action: {
                    manageTable.addNewTable()
                    editModeText()
                }, label:  { Image(systemName: "plus.circle") } )
                
            }
        }
    }
    
    private func editModeText() {
        editMode.toggle()
        if editMode == false {
            editModeInfo = "Edit"
        } else {
            editModeInfo = "Done"
        }
    }
}



struct ManageTablesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTablesView()
    }
}

