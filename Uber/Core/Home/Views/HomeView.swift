//
//  HomeView.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack (alignment: .top) {
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                MapViewActionButton()
                LocationSearchActivateView()
                    .padding(.top, 30)
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
