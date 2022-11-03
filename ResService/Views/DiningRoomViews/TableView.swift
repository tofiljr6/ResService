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
    @ObservedObject var diningRoom : DiningRoomViewModel
    
    private let boxsize = CGFloat(50)
    private let paddingconst = CGFloat(10)
    
    var body: some View {
        NavigationLink(destination: { WaiterOrderView(tableNumber: id) }) {
            ZStack {
                Rectangle()
                    .fill(color)
                    .frame(width: boxsize, height: boxsize)
                    .cornerRadius(4)
                Text(id.description)
                    .foregroundColor(.black)
            }
        }.position(location)
    }
}

struct TableView_Previews: PreviewProvider {
    @State static var manageTableViewHeight = UIScreen.main.bounds.height * 0.8
    @State static var manageTableViewWidth = UIScreen.main.bounds.width * 0.8
    @State static var editMode : Bool = false
    @ObservedObject static var manageTable = DiningRoomViewModel()
    
    static var previews: some View {
        TableView(id: 1,
                  color: .brown,
                  location: CGPoint(x: 50, y: 50),
                  manageTableViewWidth: $manageTableViewWidth,
                  manageTableViewHeight: $manageTableViewHeight, editMode: $editMode,
                  diningRoom: manageTable)
    }
}
