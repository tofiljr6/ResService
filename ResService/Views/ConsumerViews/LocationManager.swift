//
//  LocationManager.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import Foundation
import CoreLocation
import Firebase

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    private let accuration : Double = 0.002
    
    @Published var location: CLLocationCoordinate2D? // user location
    @Published var restaurantCoordinates : RestaurantLocModel?
    
    override init() {
        print("Location Manager inizalization...")
        super.init()
        
        manager.requestWhenInUseAuthorization()
        
        // set defleaut location for restaurant
        self.restaurantCoordinates = RestaurantLocModel(id: UUID())
        
        
        let refparam = Database.database(url: dbURLConnection).reference().child(paramCollectionName)
        refparam.observe(DataEventType.value, with: { snapshot in
            guard let paramsinfo = snapshot.value as? [String: Any] else { return }
            if paramsinfo["latitude"] != nil && paramsinfo["longitude"] != nil {
                let lati = paramsinfo["latitude"]!  as! Float
                let long = paramsinfo["longitude"]! as! Float
                let latidegress = CLLocationDegrees(lati)
                let longdegress = CLLocationDegrees(long)
                if self.restaurantCoordinates != nil {
                    self.restaurantCoordinates!.coordinate = CLLocationCoordinate2D(latitude: latidegress, longitude: longdegress)
                }
            }
            
            if self.restaurantCoordinates != nil {
                print(self.restaurantCoordinates!)
            }
            
            
            // avoid warining with CCLocationManager
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    self.manager.delegate = self
                    self.manager.desiredAccuracy = kCLLocationAccuracyBest
                    self.manager.startUpdatingLocation()
                }
            }
        })
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first?.coordinate != nil {
            location = locations.first!.coordinate
        }
    }
    
    func authUserLocationWithRestaurant() -> Bool {
        if self.location != nil && self.restaurantCoordinates != nil {
            let latdiff = abs(Double(self.location!.latitude) - Double(self.restaurantCoordinates!.coordinate!.latitude))
            let longdiff = abs(Double(self.location!.longitude) - Double(self.restaurantCoordinates!.coordinate!.longitude))
            
            if latdiff < accuration && longdiff < accuration {
                return true
            }
        }
        return false
    }
}
