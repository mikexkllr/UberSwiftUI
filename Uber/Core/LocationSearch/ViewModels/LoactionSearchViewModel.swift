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
    @Published var selectedLocation: MKMapItem?
    var userLocation: CLLocation?
    
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
            guard let item = response?.mapItems.first else { return }
            self?.selectedLocation = item
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
        guard let selectedDestination = selectedLocation?.placemark.location, let userLocation = self.userLocation else {
            return 0.0
        }
        
        let tripDistanceInMeter = userLocation.distance(from: selectedDestination)
        let price = type.computePrice(for: tripDistanceInMeter)

        
        return price
    }
}


// MARK: MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
