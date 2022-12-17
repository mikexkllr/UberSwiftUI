//
//  UberMapViewRepresentable.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import Foundation
import SwiftUI
import UIKit
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    @EnvironmentObject var mapViewModel: MapViewModel
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    // Making our UIKIt View + View Controller
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    // Updating and reloading our uikit view via SwiftUI state management
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("DEBUG: Map State is \(mapViewModel.mapState)")
        
        // is here to update/ rerender view -- using state management of course :)
        if let selectedLocation = locationViewModel.selectedLocation {
            print("DEBUG: Selected location in the map view \(selectedLocation.placemark.coordinate)")
            context.coordinator.addAndSelectAnnotation(withCoordinate: selectedLocation.placemark.coordinate)
            context.coordinator.configurePolyline(withDestinationCoordinate: selectedLocation.placemark.coordinate)
        }
        
        context.coordinator.updateMapView()
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        // MARK: Properties
        let parent: UberMapViewRepresentable
        var userLocation: MKUserLocation?
        var currentRegion: MKCoordinateRegion?
        
        // MARK: LIfecycle
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // span is basically the zoom
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
            self.userLocation = userLocation
        }
        
        // UIKit method which is called as soon as we add an overlay
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        // MARK: Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            self.parent.mapView.addAnnotation(annotation)
            self.parent.mapView.selectAnnotation(annotation, animated: true)
            self.parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> Void) {
            // placemark of user
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            // placemark of destination
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
            // request object which handles map kit api
            let request = MKDirections.Request()
            // setting map item start location - user location
            request.source = MKMapItem(placemark: userPlacemark)
            // setting map item destination  location
            request.destination = MKMapItem(placemark: destinationPlacemark)
            // getting object filled with directions
            let direction = MKDirections(request: request)
            // passing in callback function with right parameter to handle error and success case when api feedback is loaded
            direction.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                
                guard let route: MKRoute = response?.routes.first else {
                    return
                }
                
                // calling our function which is passed as a parameter to update our ui our other stuff
                completion(route)
            }
        }
        
        func configurePolyline(withDestinationCoordinate destinationCoordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocation?.coordinate else {
                return
            }
            
            getDestinationRoute(from: userLocationCoordinate, to: destinationCoordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                
                if self.parent.mapViewModel.mapState == .locationSelected {
                    self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
            }
        }
        
        func updateMapView() {
            print("DEBUG: Remove overlays and center the view")
            
            switch self.parent.mapViewModel.mapState {
            case .noInput:
                self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
                self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
                
                if let currentRegion = self.currentRegion {
                    self.parent.mapView.region = currentRegion
                }
                break
            case .searchingForLocation:
                break
            case .locationSelected:
                if let coordinate = parent.locationViewModel.selectedLocation?.placemark.coordinate {
                    self.addAndSelectAnnotation(withCoordinate: coordinate)
                    self.configurePolyline(withDestinationCoordinate: coordinate)
                }
                break
            }
        }
    }
}
