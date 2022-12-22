//
//  MapViewActionButton.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: MapViewState
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
        switch self.mapState {
        case .noInput:
            print("DEBUG: NO INPUT")
        case .searchingForLocation:
            self.mapState = .noInput
        case .locationSelected, .routeAdded:
            print("DEBUG: Clear the map view")
            self.mapState = .noInput
            locationViewModel.selectedLocation = nil
        }
    }
    
    func imageNameForMapViewState() -> String {
        switch self.mapState {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected:
            return "arrow.left"
        default:
            return "line.3.horizontal"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
    }
}
