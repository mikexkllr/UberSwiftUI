//
//  LocationSearchView.swift
//  uber
//
//  Created by Mike Keller on 05.12.22.
//

import SwiftUI

struct LocationSearchView: View {
    @State var startLocationText: String = ""
    @EnvironmentObject var viewModel: LocationSearchViewModel
    @EnvironmentObject var mapViewModel: MapViewModel

    var body: some View {
        VStack {
            // header view
            HStack {
                // cool ui element like in gmaps
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                }
                
                // Input fields for location and destination
                VStack {
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    TextField("Where to?", text: self.$viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.leading)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
        
            // list view
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    self.viewModel.selectLocation(result)
                                    self.mapViewModel.mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .background(Color.systemBackground)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
