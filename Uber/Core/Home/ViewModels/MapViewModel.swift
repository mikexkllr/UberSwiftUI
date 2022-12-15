//
//  MapViewModel.swift
//  uber
//
//  Created by Mike Keller on 15.12.22.
//

import Foundation

class MapViewModel: ObservableObject {
    @Published var mapState: MapViewState = .noInput
}
