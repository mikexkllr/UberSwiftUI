//
//  HomeView.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var mapViewModel: MapViewModel

    var body: some View {
        ZStack (alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable()
                    .ignoresSafeArea()
                
                if mapViewModel.mapState == .searchingForLocation {
                    LocationSearchView()
                } else if mapViewModel.mapState == .noInput {
                        // button on left corner (leading top)
                        LocationSearchActivateView()
                            .padding(.top, 60)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    self.mapViewModel.mapState = .searchingForLocation
                                }
                            }
                    }
                
                MapViewActionButton()
            }
            
            if mapViewModel.mapState == .locationSelected {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
