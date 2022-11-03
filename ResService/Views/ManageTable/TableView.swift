//
//  TableView.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/11/2022.
//

import SwiftUI

struct TableView: View {
    var id : Int
    var color : Color
    @State var location : CGPoint
    @Binding var manageTableViewWidth  : CGFloat
    @Binding var manageTableViewHeight : CGFloat
    @Binding var editMode : Bool
    @ObservedObject var manageTable : ManageTablesViewModel
    
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: boxsize, height: boxsize)
                .cornerRadius(4)
                .position(location)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if editMode {
                                location = value.location
                                print(location, UIScreen.main.bounds.width, UIScreen.main.bounds.height, manageTableViewWidth, manageTableViewHeight)
                            }
                        }
                        .onEnded { value in
                            if editMode {
                                print("do zapisania loc stolika nr \(id)")
                                
                                
                                if value.location.x < 0 {
                                    location.x = boxsize / 2
                                } else if value.location.x > manageTableViewWidth {
                                    location.x = manageTableViewWidth -  0.5 * boxsize
                                }
                                
                                if value.location.y < 0 {
                                    location.y = boxsize / 2
                                } else if value.location.y > manageTableViewHeight {
                                    location.y = manageTableViewHeight - 0.5 * boxsize
                                }
                                
                                manageTable.updateLocationForTableNumber(number: id, location: location)
                            }
                        }
                )
                .gesture(TapGesture().onEnded({ value in
                    print("Wybrano stolik numer: \(id)")
                }))
            
            
            Text("\(id)")
                .position(location)
                .foregroundColor(.black)
        }
    }
}

struct TableView_Previews: PreviewProvider {
    @State static var manageTableViewHeight = UIScreen.main.bounds.height * 0.8
    @State static var manageTableViewWidth = UIScreen.main.bounds.width * 0.8
    @State static var editMode : Bool = false
    @ObservedObject static var manageTable = ManageTablesViewModel()
    
    static var previews: some View {
        TableView(id: 1,
                  color: .brown,
                  location: CGPoint(x: 50, y: 50),
                  manageTableViewWidth: $manageTableViewWidth,
                  manageTableViewHeight: $manageTableViewHeight, editMode: $editMode,
                  manageTable: manageTable)
    }
}
