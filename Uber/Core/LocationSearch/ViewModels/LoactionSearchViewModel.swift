//
//  LoactionSearchViewModel.swift
//  uber
//
//  Created by Mike Keller on 06.12.22.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: UberLocation?
    var userLocation: CLLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    var expectedTravelTime: ExpectedTravelTime?
    
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            print("DEBUG: Query fragment is: \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = self.queryFragment
    }
    
    // MARK: Helpers
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        //self.selectedLocation = location
        self.locationSearch(forLocalSearchCompletion: localSearch) { [weak self] response, error in
            if let error = error {
                print("DEBUG: Location search finished with error \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first, let location = item.placemark.location else { return }
            self?.selectedLocation = UberLocation(title: localSearch.title, location: location)
        }
        
        print("DEBUG: Selected location is \(String(describing: localSearch.title))")
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(for type: RideType) -> Double {
        guard let selectedDestination = selectedLocation?.location, let userLocation = self.userLocation else {
            return 0.0
        }
        
        let tripDistanceInMeter = userLocation.distance(from: selectedDestination)
        let price = type.computePrice(for: tripDistanceInMeter)

        
        return price
    }
    
    // query apple maps for the destination and complete with route object which is used to display polyline on the map view
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (MKRoute, ExpectedTravelTime) -> Void) {
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
            
            // using the expected travel time to get times
            let expectedTravelTime = LocationSearchViewModel.ExpectedTravelTime.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            
            // calling our function which is passed as a parameter to update our ui our other stuff
            completion(route, expectedTravelTime)
        }
    }
    
    struct ExpectedTravelTime {
        // timestamp
        let expectedTravelTime: Double
        let pickUpTime: Date
        let dropoffTime: Date
        
        // calculates the time when you get picked up and when you arrive
        static func configurePickupAndDropoffTimes(with expectedTravelTime: Double) -> Self {
            return ExpectedTravelTime(expectedTravelTime: expectedTravelTime, pickUpTime: Date(), dropoffTime: Date() + expectedTravelTime)
        }
    }
    
    func formatPickupAndDropoffTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        self.pickupTime = formatter.string(from: self.expectedTravelTime?.pickUpTime ?? Date.now)
        self.dropOffTime = formatter.string(from: self.expectedTravelTime?.dropoffTime ?? Date.now)
    }
}


// MARK: MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
