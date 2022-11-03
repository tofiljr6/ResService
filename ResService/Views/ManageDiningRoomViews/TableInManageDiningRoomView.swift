//
//  ManageDiningRoomView.swift
//  ResService
//
//  Created by Mateusz Tofil on 03/11/2022.
//

import SwiftUI

struct TableInManageDiningRoomView: View {
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
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: boxsize, height: boxsize)
                .cornerRadius(4)
                .position(location)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                                location = value.location
                                print(location, UIScreen.main.bounds.width, UIScreen.main.bounds.height, manageTableViewWidth, manageTableViewHeight)
                        }
                        .onEnded { value in
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
                                
                                diningRoom.updateLocationForTableNumber(number: id, location: location)
                        }
                )
                .gesture(TapGesture().onEnded({ value in
                    print("Wybrano stolik numer: \(id)")
                }))
                .border(.red)
            
            
            Text("\(id)")
                .position(location)
                .foregroundColor(.black)
        }
    }
}

//struct ManageDiningRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageDiningRoomView()
//    }
//}
