//
//  LocationManager.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    private let accuration : Double = 0.00002
    
    @Published var location: CLLocationCoordinate2D?
    @Published var restaurantLocation : CLLocationCoordinate2D?
    
    override init() {
        print("Location Manager inizalization...")
        super.init()
        
        manager.requestWhenInUseAuthorization()
        
        // set defleaut location for restaurant
        self.restaurantLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(37.785834), longitude: CLLocationDegrees(22.406417))
        
        // avoid warining with CCLocationManager
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.manager.delegate = self
                self.manager.desiredAccuracy = kCLLocationAccuracyBest
                self.manager.startUpdatingLocation()
            }
        }
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
        if self.location != nil && self.restaurantLocation != nil {
            if abs(Double(self.location!.latitude) - Double(self.restaurantLocation!.latitude)) < accuration &&
                abs(Double(self.location!.longitude) - Double(self.restaurantLocation!.longitude)) < accuration {
                return true
            }
        }
        return false
    }
}
