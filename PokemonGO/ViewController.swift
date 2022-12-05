//
//  ViewController.swift
//  PokemonGO
//
//  Created by Josebe Barbosa on 08/11/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //recuperar pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarTodosPokemons()
        
        //Exibir Pokemon
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                let totalPokemons = UInt32(self.pokemons.count)
                let indicePokemonAleatorio = arc4random_uniform(totalPokemons)
                 
                let pokemon = self.pokemons[ Int(indicePokemonAleatorio) ]
                //print(pokemon.nome)
                
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                
                let latAleatoria = (Double(arc4random_uniform(500)) - 250) / 100000.0
                let longAleatoria = (Double(arc4random_uniform(500)) - 250) / 100000.0
                
                anotacao.coordinate.latitude  += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
                
                self.mapa.addAnnotation(anotacao)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
          
        if annotation is MKUserLocation {
            anotacaoView.image = UIImage.init(named: "player.png")
        } else {
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            anotacaoView.image = UIImage.init(named: pokemon.nomeImagem!)
        }
    
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let anotacao = view.annotation
        
        if anotacao is MKUserLocation {
            return
        }
        
        let pokemon = (anotacao as! PokemonAnotacao).pokemon
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if let coordenadaAnotacao = anotacao?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let regiao = MKCoordinateRegion(center: coordenadaAnotacao, span: span)
            
            self.mapa.setRegion(regiao, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coordenadaUser = self.gerenciadorLocalizacao.location?.coordinate {
                let pointUser = MKMapPoint(coordenadaUser)
                
                if self.mapa.visibleMapRect.contains(pointUser){
                    print("Você pode capturar o pokemon")
                    self.coreDataPokemon.updatePokemon(pokemon: pokemon)
                    self.mapa.removeAnnotation(anotacao!)
                    
                    let alertController = UIAlertController(title: "Parabéns", message: "Você capturou o pokemon: \(pokemon.nome!)", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default)
                    
                    alertController.addAction(actionOk)
                    
                    self.present(alertController, animated: true)
                } else {
                    let alertController = UIAlertController(title: "Você não pode capturar", message: "Você precisa se aproximar mais para capturar o \(pokemon.nome!)", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default)
                    
                    alertController.addAction(actionOk)
                    
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contador < 3 {
            centralizar()
            
            contador += 1
            print("executou!")
        } else {
            gerenciadorLocalizacao.stopUpdatingLocation()
            print("Parou de executar!")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status != .authorizedWhenInUse && status != .notDetermined{
            let alerta = UIAlertController(title: "Autorização de Localização", message: "Necessario a localização para o funcionamento do app!", preferredStyle: .alert)
            
            let actionConfig = UIAlertAction(title: "Configuração", style: .default) { (alertaConfiguracao) in
                if let configuracao = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracao as URL)
                }
            }
            
            let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel)
            
            alerta.addAction(actionConfig)
            alerta.addAction(actionCancel)
            
            present(alerta, animated: true)
        }
    }
    
    func centralizar() {
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion.init(center: coordenadas, span: span)
            
            mapa.setRegion(region, animated: true)
        }
    }
    
    @IBAction func btnCentralizarJogador(_ sender: Any) {
        centralizar()
    }
    
    @IBAction func btnAbrirPokedex(_ sender: Any) {
        
    }
}
