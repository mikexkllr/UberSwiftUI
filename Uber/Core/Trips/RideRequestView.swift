//
//  RideRequestView.swift
//  uber
//
//  Created by Mike Keller on 16.12.22.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = RideType.uberX
    @EnvironmentObject private var locationSearchViewModel: LocationSearchViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            // trip information
            HStack {
                // cool ui element like in gmaps
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                }
                
                // Current location and destination location
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Current Location")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)

                        Spacer()
                        
                        Text("1:30 PM")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Starbucks Coffee")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Spacer()
                        
                        Text("1:45 PM")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 10)
            }
            .padding()
            
            Divider()
            
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // ride type selection view
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases, id: \.self) { rideType in
                        // card element which is used to display the selection
                        VStack(alignment: .leading) {
                            Image(rideType.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(rideType.description)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("\(self.locationSearchViewModel.computeRidePrice(for: rideType).toCurrency() ?? "Error")")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding()
                        }
                        .frame(width: 112, height: 140)
                        .foregroundColor(rideType == self.selectedRideType ? .white : .black)
                        .background(Color(self.selectedRideType == rideType ? .systemBlue :  .systemGroupedBackground))
                        .scaleEffect(rideType == selectedRideType ? 1.20 : 1.00)
                        .cornerRadius(15)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                self.selectedRideType = rideType
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            // payment option view
            HStack(spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** 1234")
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height: 50)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Divider()
            
            // request ride button
            Button {
                
            } label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
        }
        .padding(.bottom, 24)
        .background(.white)
        .cornerRadius(18)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
    }
}
