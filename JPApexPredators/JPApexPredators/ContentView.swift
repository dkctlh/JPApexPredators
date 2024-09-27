//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Talha Dikici on 17.09.2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var searchText = ""
    @State var alphabetical = false
    @State var currentSelection = PredatorType.all
    @State var currentMovieSelection = Movies.all
    @State var deletingItemId = ""
    
    let predators = Predators()
    
    var filteredDinos: [ApexPredator] {
        predators.removeDino(dinoId: deletingItemId)
        
        predators.filter(by: currentSelection, movie: currentMovieSelection)
        
        predators.sort(by: alphabetical)
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List(filteredDinos) { predator in
                NavigationLink {
                    PredatorDetail(predator: predator, position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000)))
                } label: {
                    HStack {
                        //Dinasour Image
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .white, radius: 1)
                        VStack(alignment: .leading){
                            //Name
                            Text(predator.name)
                                .fontWeight(.bold)
                            
                            //Type
                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(predator.type.background)
                                .clipShape(.capsule)
                        }
                    }
                    .swipeActions(edge: .leading){
                        Button(role: .destructive){
                            deletingItemId = String(predator.id)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            alphabetical.toggle()
                        }
                    } label: {
                        Image(systemName: alphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: alphabetical)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section(header: Text("By Type")){
                            Picker("Filter", selection: $currentSelection.animation()) {
                                ForEach( PredatorType.allCases) { type in
                                    Label(type.rawValue.capitalized, systemImage: type.icon)
                                }
                            }
                        }
                        Section(header: Text("By Movies")){
                            Picker("MovieFilter", selection: $currentMovieSelection.animation()) {
                                ForEach(Movies.allCases, id:\.self) { movie in
                                    Label(movie.rawValue.capitalized, systemImage: "film")
                                }
                            }
                        }
                        
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
