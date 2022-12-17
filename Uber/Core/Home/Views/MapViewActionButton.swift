//
//  MapViewActionButton.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct MapViewActionButton: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState()
            }
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color.systemBackground)
                    .shadow(color: .black, radius: 3)
                
                Image(systemName: self.imageNameForMapViewState())
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 40)
    }
    
    func actionForState() {
        switch self.mapViewModel.mapState {
        case .noInput:
            print("DEBUG: NO INPUT")
        case .searchingForLocation:
            self.mapViewModel.mapState = .noInput
        case .locationSelected:
            print("DEBUG: Clear the map view")
            mapViewModel.mapState = .noInput
            locationViewModel.selectedLocation = nil
        }
    }
    
    func imageNameForMapViewState() -> String {
        switch self.mapViewModel.mapState {
        case .noInput:
            return "line.3.horizontal"
        default:
            return "arrow.left"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton()
    }
}
