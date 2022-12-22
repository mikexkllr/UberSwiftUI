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
    @Binding var mapState: MapViewState
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
        print("DEBUG: Map State is \(mapState)")
        // is here to update/ rerender view -- using state management of course :)
        if let coordinate = self.locationViewModel.selectedLocation?.location.coordinate {
            print("DEBUG: add polyline and annotations")
            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
            context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
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
        var calledTimes: Int = 0
        
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
        
        // is here to select the place with a pinmark
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            // a string-based piece of location-specific data that you apply to a specific point on a map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            self.parent.mapView.addAnnotation(annotation)
            self.parent.mapView.selectAnnotation(annotation, animated: true)
            self.parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
            
            print("DEBUG: Add annotation to map (pinmark)")
        }
        

        
        func configurePolyline(withDestinationCoordinate destinationCoordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocation?.coordinate else {
                return
            }
            
            self.calledTimes += 1
            print("How many times configure polyline is called: \(calledTimes)")
            
            self.parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: destinationCoordinate) {  route, expectedTravelTime in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.locationViewModel.expectedTravelTime = expectedTravelTime
    
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                self.parent.mapState = .routeAdded
            }
        }
        
        func updateMapView() {
            print("DEBUG: update map view")
            
            switch self.parent.mapState {
            case .noInput:
                print("DEBUG: Remove overlays and center the view")
                self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
                self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
                
                if let currentRegion = self.currentRegion {
                    self.parent.mapView.region = currentRegion
                }
                break
            case .searchingForLocation:
                break
            case .locationSelected:
                // i tried to update the map here but somehow it didn`t worked properly because of swiftui state management
                break
            case .routeAdded:
                break
            }
        }
    }
}
