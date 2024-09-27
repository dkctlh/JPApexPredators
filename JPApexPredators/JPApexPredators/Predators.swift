//
//  Predators.swift
//  JPApexPredators
//
//  Created by Talha Dikici on 17.09.2024.
//

import Foundation

class Predators {
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []
    var tmpPredators: [ApexPredator] = []
    
    init() {
        decodeApexPredatorData()
    }
    
    func decodeApexPredatorData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: ".json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                allApexPredators = try decoder.decode([ApexPredator].self, from: data)
                apexPredators = allApexPredators
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }
    
    func search(for searchTerm: String) -> [ApexPredator] {
        if searchTerm.isEmpty {
            return apexPredators
        } else {
            return apexPredators.filter {predator in
                predator.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func sort(by alphabetical: Bool) {
        apexPredators.sort { predator1, predator2 in
            if alphabetical {
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
    }
    func filter(by type: PredatorType, movie: Movies) {
        if type == .all && movie == .all {
            apexPredators = allApexPredators
        } else if movie == .all{
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        } else if type == .all {
            apexPredators = allApexPredators.filter { predator in
                predator.movies.contains(movie)
            }
        } else {
            apexPredators = allApexPredators.filter { predator in
                predator.movies.contains(movie) && predator.type == type
            }
        }
    }
    
    func removeDino (dinoId: String) {
        if let index = allApexPredators.firstIndex(where: { $0.id == Int(dinoId) }){
            allApexPredators.remove(at: index)
        }
        
    }
}
