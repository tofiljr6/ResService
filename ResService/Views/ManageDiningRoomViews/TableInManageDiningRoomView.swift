//
//  ManageDiningRoomView.swift
//  ResService
//
//  Created by Mateusz Tofil on 03/11/2022.
//

import SwiftUI

struct TableInManageDiningRoomView: Table {
    @State var tableInfo : TableInfo
    @Binding var manageTableViewWidth  : CGFloat
    @Binding var manageTableViewHeight : CGFloat
    @Binding var editMode : Bool
    @ObservedObject var diningRoom : DiningRoomViewModel
    
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    @State private var showingAlert : Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(tableInfo.status)
                .frame(width: boxsize, height: boxsize)
                .cornerRadius(4)
                .position(tableInfo.location)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                                tableInfo.location = value.location
                        }
                        .onEnded { value in
                                print("do zapisania loc stolika nr \(tableInfo.id)")
                                
                                if value.location.x < 0 {
                                    tableInfo.location.x = boxsize / 2
                                } else if value.location.x > manageTableViewWidth {
                                    tableInfo.location.x = manageTableViewWidth -  0.5 * boxsize
                                }
                                
                                if value.location.y < 0 {
                                    tableInfo.location.y = boxsize / 2
                                } else if value.location.y > manageTableViewHeight {
                                    tableInfo.location.y = manageTableViewHeight - 0.5 * boxsize
                                }
                                
                            diningRoom.updateLocationForTableNumber(number: tableInfo.id, location: tableInfo.location)
                        }
                )
                .gesture(
                    LongPressGesture().onEnded({ value in
                        showingAlert = true
                    })
                )
                .border(.red)
                .alert("Do you want to delete table number \(tableInfo.id)", isPresented: $showingAlert) {
                    Button("Yes") { diningRoom.deleteTable(number: tableInfo.id) }
                    Button("No") { }
                }
            Text("\(tableInfo.id)")
                .position(tableInfo.location)
                .foregroundColor(.black)
        }
    }
}

struct TableInManageDiningRoomView_Previews: PreviewProvider {
    @State static var manageTableViewHeight = UIScreen.main.bounds.height * 0.8
    @State static var manageTableViewWidth = UIScreen.main.bounds.width * 0.8
    @State static var editMode : Bool = false
    @ObservedObject static var manageTable = DiningRoomViewModel()


    static var previews: some View {
        TableInManageDiningRoomView(tableInfo: TableInfo(id: 1, status: .green, location: CGPoint(x: 30, y: 30)), manageTableViewWidth: $manageTableViewWidth, manageTableViewHeight: $manageTableViewHeight, editMode: $editMode, diningRoom: manageTable)
    }
}
