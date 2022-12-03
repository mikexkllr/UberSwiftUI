//
//  LocationSearchActivateView.swift
//  uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

struct LocationSearchActivateView: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            
            Text("Where do you wanna go?")
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 20)
            .fill(Color.systemBackground)
            .shadow(radius: 3)
        )
    }
}

struct LocationSearchActivateView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivateView()
    }
}
