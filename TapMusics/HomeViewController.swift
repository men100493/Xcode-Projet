//
//  HomeViewController.swift
//  TapMusics
//
//  Created by MENES SIMEU on 12/01/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource,CLLocationManagerDelegate{
    
    
    //API Météo
    //debut de  l'url de l'api openweather map
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather?lat="
    //Code de l'api
    private let openWeatherMapAPIKey = "a16d5a35a649b064ce60f14256407e15"
    //string vide qui contiendra l'adresse de connexction a l'api
    private var openWeatherURL:String = ""
    
    
    //Table view qui affiche les style de musique
    @IBOutlet weak var tableView: UITableView!
    
    //Tableau qui contient  les style de musique
    var soundStyle = ["Techno","Hip-Hop","Dance","HardCore"]
    //BG image view
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var bg2: UIImageView!
    //Couleur du l'image view de fond
    var color : UIColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    
    
    
    
    //Son techno
    var soundTechno1: [String] = ["beat21","beat22","beat23","beat24","beat25"]
    var soundTechno2: [String] = ["effect21","effect22","effect23","effect24","effect25"]
    var soundTechno3: [String] = ["melo21","melo22","melo23","melo24","melo25"]
    var soundTechno4: [String] = ["voix21","voix22","voix23","voix24","voix25"]
    
    //Son dance
    var soundDance1: [String] = ["beat31","beat32","beat33","beat34","beat35"]
    var soundDance2: [String] = ["effect31","effect32","effect33","effect34","effect35"]
    var soundDance3: [String] = ["melo31","melo32","melo33","melo34","melo35"]
    var soundDance4: [String] = ["voix31","voix32","voix33","voix34","voix35"]
    
    //Son hardcore
    var soundHardcore1: [String] = ["beat41","beat42","beat43","beat44","beat45"]
    var soundHardcore2: [String] = ["effect41","effect42","effect43","effect44","effect45"]
    var soundHardcore3: [String] = ["melo41","melo42","melo43","melo44","melo45"]
    var soundHardcore4: [String] = ["voix41","voix42","voix43","voix44","voix45"]

    
    //LOCATION
    //Location manager
    let locationManager = CLLocationManager()
    //object permetant de recupere la localisation
    let currentlocation = CLLocation()
    
    //Coordonnées GPS du device
    //label qui affiche lat et long
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    
    //String pour manipulé la ville et les coordonées
    var lat : String = ""
    var long : String = ""
    var city: String = ""
    
    //VILLE
    // Label pour la ville
    @IBOutlet weak var cityLabel: UILabel!
    var addresse: String = ""
    //TIME
    //Label de l'horloge
    @IBOutlet weak var timeLabel: UILabel!
    
    //Meteo
    // Dictionnaire pour recupere les données fournis par l'api
    var jsonData: AnyObject?
    // temperature
    var cityTemp: String = ""
    //label qui affiche la temperature
    @IBOutlet weak var cityTempLabel: UILabel!
    

    override func viewDidLoad() {
        //initilisation de la vue
        super.viewDidLoad()
        //initilisation de la table View
        tableView.dataSource = self
        tableView.delegate = self
        
        // Couleur appliqué au fond d'ecran
        background.backgroundColor = color
        bg2.backgroundColor = color
        
        //le label du temperature et caché tant que la temperature n'ets pas recu pas l'api
        cityTempLabel.isHidden = true
        
        // programmation du timer
        _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);

        
        //Location Manager  initialisation
        // assigning the delegate to location manager
        locationManager.delegate = self
        // demande l'autorisation en fonction du info.plist
        locationManager.requestAlwaysAuthorization()
        //debut de la localisation
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // mise a jour chauqe seconde du timer
    func update() {
        //le texte du time label est le curent time du telephone
        timeLabel.text = currentTime()
        //mise jour de la couleur du fond
        background.backgroundColor = self.color
        
    }
    //Fonction qui renvoie la taille de la table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.soundStyle.count
    }
    
    //function qui ajoute à chaque cell le texte du tableau des son
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //création de la cellule
        let cell = UITableViewCell()
        // modification du texte de la cellule
        cell.textLabel?.text = self.soundStyle[indexPath.row]
        
        return cell;
    }
    
    //action a chaque clic que la cellule
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        // actionement du segue lors du clic sur la cellule
        performSegue(withIdentifier: "oneSegue", sender: cell?.textLabel?.text)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    
    func currentTime() -> String {
        //création du temps ou bon format
        //récuperation de la date
        let date = Date()
        let calendar = Calendar.current
        // c'éation de heure minutes sec
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        // revois la date au bon format
        return "\(hour):\(minutes):\(sec)"
    }
    
    
    //fonction qui ce met a jour à chaque modification de la localisation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // la fonction revois un tableu de position recupération de la prémiere
        var currentLocation = locations[0]
        // si le device nous autorise a utilisé ses coordonées
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            //récuperation de la position du locatino manager
            currentLocation = locationManager.location!
            
            // récupération des coordonées GPS
            lat = currentLocation.coordinate.latitude.description
            long = currentLocation.coordinate.longitude.description
            
            //découpages des coordonées et ajout au label de latitudes et de longitudes
            latitude.text = String(lat.characters.prefix(4))
            longitude.text = String(long.characters.prefix(4))
            
            //Création du géocoder qui va nous permetre de récuperé la ville et le pays
            let geocoder = CLGeocoder()
            //fonctiond de GeocodeLocation inverser
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
                
                
                    // Place details
                    var placeMark: CLPlacemark!
                    //récupération des détail de la location sous forme de dictionnaire
                    placeMark = placemarks?[0]
                
                    if (placeMark != nil){
                        // Address dictionary
                        //print(placeMark.addressDictionary as Any, terminator: "")
                        
                        // Recuperation de la ville dans le dictionaire
                        if let city = placeMark.addressDictionary!["City"] as? NSString {
                            
                            //print(city, terminator: "")
                            //ajout de la ville dans les varibles adresse et city
                            self.addresse = city as String
                            self.city = city as String
                        }
                    
                        // Recuperation du pays dans le dictionaire
                        if let country = placeMark.addressDictionary!["Country"] as?    NSString {
                            //print(country, terminator: "")
                            //ajout dans la varibles adresse le pays
                            self.addresse += ", "
                            self.addresse += country as String
                    }
                    // mise à jour de l'adresse label
                    self.cityLabel.text = self.addresse
                }
                    //print(self.addresse)
                if error != nil {
                    // en cas d'erreur on arrete la localisation
                    self.locationManager.stopUpdatingLocation()
                }

                
            })
            
            //Mise a jour URl météo pour la connexion a l'api
            if ( self.city != "" && cityTempLabel.isHidden){
                // début de l'URL
                openWeatherURL =  openWeatherMapBaseURL
                // ajout de la latitude
                openWeatherURL += lat
                // ajout de la logitude
                openWeatherURL += "&lon="
                openWeatherURL += long
                //ajout de API ID
                openWeatherURL += "&appid="
                openWeatherURL += openWeatherMapAPIKey
                //print (openWeatherURL)
                
                //Recuperation des données avec l'URL correct
                getWeatherData(urlString: openWeatherURL)
                
            }

        }
    }

    //Fonction qui ce connect a l'api
    func getWeatherData(urlString: String) {
        //Création de l'URL
        let url = NSURL(string: urlString)
        //créction de la requete a l'api
        let task = URLSession.shared.dataTask(with: (url)! as URL as URL, completionHandler: { (data, response, error) -> Void in
            do{
                // recupération de JSON Réponse
                let str = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
                // envoi de la réponse de l'api a la fonction qui vas traité la reponse en JSON
                self.updateMeteo(meteoData: data! as NSData)
                
                print(str)
            }
            catch {
                // en cas d'erreur
                print("json error: \(error)")
                // on vide l'URL
                self.openWeatherURL = ""
            }
        })
        task.resume()
        
        
    }
    
    func updateMeteo( meteoData :NSData){
        do {
            
            // récuperation des données JSON
            self.jsonData = try JSONSerialization.jsonObject(with: meteoData as Data, options: []) as! NSDictionary
            
            //Récuperation dans le tableau JSON du "main"
            if let main = jsonData!["main"] as? NSDictionary {
                // recupération de la données "temp"
                if let temp = main["temp"] as? Double {
                    // mise a jour de la valur de la température
                    cityTemp = String(format: "%.2f", temp)
                    //affichage de le température
                    cityTempLabel.isHidden = false
                    //Convertion de kelvin a celsius
                    let tempconv = temp - 273.15
                    //Modification du format de la température
                    let tempString : String = String(format: "%.1f" ,tempconv)
                    // ajout de la temperature au label
                    cityTempLabel.text = tempString + "\u{00B0}"
                    
                }
            }
            
            //if let weatherImage = jsonData!["weather"][0]["icon"].stringValue as? String {
            //   print(weatherImage)
            //}
            
        } catch {
            //error handle here
            
        }
        
        
        

    
    }
   
    
    // Focntion qui est appler avec le segue unwindToHome
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
        //print (segue.source)
        // Recuperation du sourcce View Controller
        let SrcViewController : BackgroundViewController = segue.source as! BackgroundViewController
        // Si une image est envoyer par le view controller
        if (SrcViewController.ImageChoice?.image != nil ){
            //Modification du fon d'ecran en fonction de l'image envoiyer viea le  Segue
            self.background.image = SrcViewController.ImageChoice?.image
        
        }else{
            // si erreur 
            // image de fond null si  erreur
            self.background.image = nil
            // Recuperation de la couleur du view concoleur
            self.color = (SrcViewController.ImageChoice?.backgroundColor)!
            
        }
        // print("Menes Menes Menes")
    }

    
    //Fonction qui ce lance avant de changer de View controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Verification du Vienw controller
        if ( segue.identifier == "oneSegue" && sender != nil){
            
            //création du view controller destination
            let DestViewController : ViewController = segue.destination as! ViewController
            //Modification du titre du view controller destination
            DestViewController.titre = (sender as? String)!
             //Moification des son en fonction du sender cad du choix dans la table View
            if ((sender as? String) == "Hip-hop"){
                //ce sont les son par default
            }
            
            if ((sender as? String) == "Techno"){
                
                //transfere de son
                DestViewController.sound1 = soundTechno1
                DestViewController.sound2 = soundTechno2
                DestViewController.sound3 = soundTechno3
                DestViewController.sound4 = soundTechno4
                
            }
            if ((sender as? String) == "Dance"){
                
                //transfere de son
                DestViewController.sound1 = soundDance1
                DestViewController.sound2 = soundDance2
                DestViewController.sound3 = soundDance3
                DestViewController.sound4 = soundDance4
            }

            if ((sender as? String) == "HardCore"){
                //transfere de son
                DestViewController.sound1 = soundHardcore1
                DestViewController.sound2 = soundHardcore2
                DestViewController.sound3 = soundHardcore3
                DestViewController.sound4 = soundHardcore4
            }

            
            
            
        }
        
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
