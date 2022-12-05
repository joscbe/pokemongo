//
//  CoreDataPokemon.swift
//  PokemonGO
//
//  Created by Josebe Barbosa on 11/11/22.
//

import UIKit
import CoreData


class CoreDataPokemon {
    
    //Recuperar o contexto
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        return context!
    }
    //adcionar todos os pokemons
    func adicionarTodosPokemons(){
        let context = self.getContext()
        
        self.criarPokemon(nome: "Pikachu", nomeImagem: "pikachu-2.png", capturado: true )
        self.criarPokemon(nome: "Bellsprout", nomeImagem: "bellsprout.png", capturado: false)
        self.criarPokemon(nome: "Bullbasaur", nomeImagem: "bullbasaur.png", capturado: false)
        self.criarPokemon(nome: "Caterpie", nomeImagem: "caterpie.png", capturado: false)
        self.criarPokemon(nome: "Charmander", nomeImagem: "charmander.png", capturado: false)
        self.criarPokemon(nome: "Meowth", nomeImagem: "meowth.png", capturado: false)
        self.criarPokemon(nome: "Mew", nomeImagem: "mew.png", capturado: false)
        self.criarPokemon(nome: "Psyduck", nomeImagem: "psyduck.png", capturado: false)
        self.criarPokemon(nome: "Rattata", nomeImagem: "rattata.png", capturado: false)
        self.criarPokemon(nome: "Snorlax", nomeImagem: "snorlax.png", capturado: false)
        self.criarPokemon(nome: "Squirtle", nomeImagem: "squirtle.png", capturado: false)
        self.criarPokemon(nome: "Zubat", nomeImagem: "zubat.png", capturado: false)
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar pokemon!!")
        }
        
    }
    //criar os pokemons
    func criarPokemon(nome: String, nomeImagem: String, capturado: Bool){
        let context = self.getContext()
        let pokemon = Pokemon.init(context: context)
        
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
    }
    
    //Recuperar todos os pokemons
    func recuperarTodosPokemons() -> [Pokemon] {
        let context = self.getContext()
        
        do {
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0 {
                self.adicionarTodosPokemons()
                return self.recuperarTodosPokemons() 
            }
            
            return pokemons
        } catch  {
            print("lista vazia!!")
        }
        
        return []
    }
    
    func recuperarPokemonCapturado(capturado: Bool) -> [Pokemon] {
        let context = self.getContext()
        
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        requisicao.predicate = NSPredicate(format: "capturado = %i", capturado as CVarArg)
        
        do {
            let pokemons = try context.fetch(requisicao) as [Pokemon]
            
            return pokemons
        } catch {
            print("Erro ao buscar lista!!")
        }
        
        return []
    }
    
    func updatePokemon(pokemon: Pokemon) {
        let context = self.getContext()
        pokemon.capturado = true
        
        do {
            try context.save()
        } catch {
            print("Erro ao atualizar pokemon")
        }
    }
}
