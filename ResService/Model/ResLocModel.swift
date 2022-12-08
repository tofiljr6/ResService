//
//  ResLocModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 02/12/2022.
//

import Foundation
import MapKit

struct RestaurantLocModel : Identifiable {
    var id : UUID
    var coordinate : CLLocationCoordinate2D?
}
