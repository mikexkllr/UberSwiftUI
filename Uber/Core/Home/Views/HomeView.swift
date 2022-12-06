//
//  HomeView.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchView = false
    var body: some View {
        ZStack (alignment: .top) {
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
                if showLocationSearchView {
                    LocationSearchView()
                } else {
                    LocationSearchActivateView()
                        .padding(.top, 60)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showLocationSearchView.toggle()
                            }
                        }
                }
            
            MapViewActionButton(clicked: $showLocationSearchView)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
