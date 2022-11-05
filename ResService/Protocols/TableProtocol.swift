//
//  TableProtocol.swift
//  ResService
//
//  Created by Mateusz Tofil on 05/11/2022.
//

import Foundation
import SwiftUI

protocol Table : View {
    var tableInfo : TableInfo { get set }
    var manageTableViewWidth  : CGFloat { get set }
    var manageTableViewHeight : CGFloat { get set }
    var editMode : Bool { get set }
    var diningRoom : DiningRoomViewModel { get set }
}
