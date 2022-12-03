//
//  MapViewActionButton.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct MapViewActionButton: View {
    var body: some View {
        Button {
            
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color.systemBackground)
                    .shadow(color: .black, radius: 3)
                
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 40)
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton()
    }
}
