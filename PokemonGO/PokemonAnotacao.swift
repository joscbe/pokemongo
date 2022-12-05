//
//  PokemonAnotacao.swift
//  PokemonGO
//
//  Created by Josebe Barbosa on 12/11/22.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
