//
//  ChangeLocationView.swift
//  ResService
//
//  Created by Mateusz Tofil on 16/11/2022.
//

import SwiftUI
import MapKit
import UIKit
import Firebase
import Foundation

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @EnvironmentObject var restaurantLocationModel : RestaurantLocationViewModel
    
    var restaurantLOC = MKPointAnnotation()
    var oldCoordinate = MKPointAnnotation()
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        // Creates the view object and configures its initial state
        mapView.delegate = context.coordinator
        
        // restauranc Loc
        restaurantLOC.coordinate = restaurantLocationModel.restaurantCoordinates
        self.mapView.addAnnotation(self.restaurantLOC)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // Updates the state of the specified view with new information from SwiftUI.
        self.mapView.addAnnotation(self.restaurantLOC)
    }
    
    func makeCoordinator() -> Coordinator {
        // Creates the custom instance that you use to communicate changes from your view to other parts of your SwiftUI interface.
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        var gRecognizer = UILongPressGestureRecognizer()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }
        
        @objc func tapHandler(_ gesture: UILongPressGestureRecognizer) {
            // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
            self.parent.centerCoordinate = coordinate
            self.parent.restaurantLocationModel.upToDateCoordinates(coordinates: coordinate)
            
            // delete old anotation
            self.parent.mapView.removeAnnotation(self.parent.restaurantLOC)
            
            // set new annotation
            self.parent.restaurantLOC.coordinate = coordinate
            self.parent.mapView.addAnnotation(self.parent.restaurantLOC)
        }
    }
}


struct ChangeLocationView: View {
    @State var location = CLLocationCoordinate2D(latitude: 51.18, longitude: 16.73)
    @EnvironmentObject var restaurantLocationModel : RestaurantLocationViewModel
    
    var body: some View {
        MapView(centerCoordinate: $location)
            .edgesIgnoringSafeArea(.bottom)
            .environmentObject(restaurantLocationModel)
            .navigationTitle("Restaurant coords")
    }
}


struct ChangeLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangeLocationView()
                .navigationTitle("Restaurant coords")
        }
    }
}
