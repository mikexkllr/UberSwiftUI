//
//  HomeView.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    @State var mapState: MapViewState = .noInput

    var body: some View {
        ZStack (alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: self.$mapState)
                    .ignoresSafeArea()
                
                if self.mapState == .searchingForLocation {
                    LocationSearchView(mapState: self.$mapState)
                } else if self.mapState == .noInput {
                        // button on left corner (leading top)
                        LocationSearchActivateView()
                            .padding(.top, 60)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    self.mapState = .searchingForLocation
                                }
                            }
                    }
                
                MapViewActionButton(mapState: self.$mapState)
            }
            
            if self.mapState == .routeAdded {
                RideRequestView()
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        self.locationSearchViewModel.formatPickupAndDropoffTime()
                    }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                print("DEBUG: User location in Home View is location \(location.coordinate)")
                self.locationSearchViewModel.userLocation = location
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
