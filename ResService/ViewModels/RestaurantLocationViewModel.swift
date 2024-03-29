//
//  RestaurantLocationViewModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 16/11/2022.
//

import Foundation
import MapKit
import Firebase



final class RestaurantLocationViewModel : ObservableObject {
    @Published var restaurantCoordinates : RestaurantLocModel
    
    init() {
        self.restaurantCoordinates = RestaurantLocModel(id: UUID())
        
        
        let refparam = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        refparam.observe(DataEventType.value, with: { snapshot in
            guard let paramsinfo = snapshot.value as? [String: Any] else { return }
            if paramsinfo["latitude"] != nil && paramsinfo["longitude"] != nil {
                let lati = paramsinfo["latitude"]!  as! Float
                let long = paramsinfo["longitude"]! as! Float
                let latidegress = CLLocationDegrees(lati)
                let longdegress = CLLocationDegrees(long)
                self.restaurantCoordinates.coordinate = CLLocationCoordinate2D(latitude: latidegress, longitude: longdegress)
            }
        })
        
    }
    
    func upToDateCoordinates(coordinates : CLLocationCoordinate2D) -> Void {
        self.restaurantCoordinates.coordinate = coordinates
        
        let refparam = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        refparam.updateChildValues(["latitude" : Float(coordinates.latitude),
                                    "longitude": Float(coordinates.longitude)])
    }
}
