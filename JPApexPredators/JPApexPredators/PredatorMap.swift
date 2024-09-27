//
//  PredatorMap.swift
//  JPApexPredators
//
//  Created by Talha Dikici on 17.09.2024.
//

import SwiftUI
import MapKit

struct PredatorMap: View {
    let predators = Predators()
    @State var satellite = false
    
    @State var position: MapCameraPosition
    
    var body: some View {
        Map(position: $position) {
            ForEach(predators.allApexPredators) {predator in
                Annotation(predator.name, coordinate: predator.location) {
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .shadow(color: .white, radius: 3)
                        .scaleEffect(x: -1)
                }
            }
        }
        .mapStyle(satellite ? .imagery(elevation: .realistic) : .standard(elevation: .realistic))
        .overlay(alignment: .bottomTrailing) {
            Button {
                satellite.toggle()
            } label: {
                Image(systemName: satellite ? "globe.americas.fill" : "globe.americas")
                    .font(.largeTitle)
                    .imageScale(.large  )
                    .padding(3)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 7))
                    .shadow(radius: 3)
                    .padding()
            }
        }
        .toolbarBackground(.automatic)
    }
}

#Preview {
    PredatorMap(position: .camera(MapCamera(centerCoordinate: Predators().apexPredators[2].location, distance: 300, heading: 250, pitch: 80))
    )
        .preferredColorScheme(.dark)
   
}
