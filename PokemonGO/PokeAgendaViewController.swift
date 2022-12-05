//
//  PokeAgendaViewController.swift
//  PokemonGO
//
//  Created by Josebe Barbosa on 12/11/22.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var pokemonsCapturado: [Pokemon] = []
    var pokemonsNaoCapturado: [Pokemon] = []

    @IBAction func voltarMapa(_ sender: Any) {
        dismiss(animated: true )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreData = CoreDataPokemon()
        
        self.pokemonsCapturado = coreData.recuperarPokemonCapturado(capturado: true)
        self.pokemonsNaoCapturado = coreData.recuperarPokemonCapturado(capturado: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        } else {
            return "Não Recuperados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.pokemonsCapturado.count
        } else {
            return self.pokemonsNaoCapturado.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pokemon: Pokemon!
        
        if indexPath.section == 0 {
            pokemon = self.pokemonsCapturado[indexPath.row]
        } else {
            pokemon = self.pokemonsNaoCapturado[indexPath.row]
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = pokemon.nome
        cell.imageView?.image = UIImage(named: pokemon.nomeImagem!)
        
        return cell
    }
}
