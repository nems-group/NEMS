//
//  LocationVC.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        locationManager.delegate = self
        
//        let json = try? JSONSerialization.jsonObject(with: LocalData.shared.json) as? [String:Any]
//
//        if let dataRates = json!!["Location"] as? [[String: Any]] {
//            print(dataRates[0])
//        }
        
        
        ModelStore.shared.allLocations = self.locationFromData(LocalData.shared.json)
        
        if ModelStore.shared.allLocations.count == 0 {
            ModelStore.shared.allLocations.append(Location(name: "Stockton", address: "1520 Stockton St.", city: "San Francisco", state: "Ca", zip: "", phone: "", clinicHours: "", pharmacyHours: "", description: "Our main clinic on 1520 Stockton Street in Chinatown/North Beach", transportation: "", image: "locationsStockton", latitude: "37.799934", longitude: "-122.408724"))
            ModelStore.shared.allLocations.append(Location(name: "San Bruno", address: "2574 San Bruno Ave.", city: "San Francisco", state: "Ca", zip: "", phone: "", clinicHours: "", pharmacyHours: "", description: "Our 2574 San Bruno clinic in the Portola District opened in December 2009", transportation: "", image: "locationsPortola", latitude: "37.729605", longitude: "-122.404497"))
        }
    
        
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        _ = tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelStore.shared.allLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let location = ModelStore.shared.allLocations[indexPath.row]
        
        cell.textLabel!.text = location.name
       
        return cell
    }

    // MARK: - clickable Table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = ModelStore.shared.allLocations[indexPath.row]
        locationImageView.image = UIImage(named: location.image!)
        
        ModelStore.shared.selectedLocation = ModelStore.shared.allLocations[indexPath.row]
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(Float(ModelStore.shared.allLocations[indexPath.row].latitude!)!), longitude: CLLocationDegrees(Float(ModelStore.shared.allLocations[indexPath.row].longitude!)!)), span: MKCoordinateSpan(latitudeDelta: 0.0009, longitudeDelta: 0.0009))
        mapView.setRegion(region, animated: true)
        
    }

    // Mark: Parser
    func locationFromData(_ data: Data?) -> [Location] {
        //No data, return an empty array
        guard let data = data else {
            return []
        }
        
        //parse the Data into JSON Object
        let JSONObject = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
        //print("JSONObject: \(JSONObject)")
        
        //insist that this object must be a dictionary
        guard let JSONDictionary = JSONObject as? [String: Any] else {
            assertionFailure("Failed to parse data. data.length: \(data.count)")
            return [Location]()
        }
        
        // Print the object, for now, so we can take a look
        //print("JSONDictionary: \(JSONDictionary)")
        
        // Pretty Print the string, for debugging
        //let prettyData = try! JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted)
        //let prettyString = String(data: prettyData, encoding: String.Encoding.utf8)
        //print(prettyString ?? "No String Available")
        
        let locationDictionaries = JSONDictionary["Location"] as! [[String : Any]]
        
//        for item in locationDictionaries {
//            print("name \(item["name"])")
//            print("address \(item["address"])")
//            print("image \(item["image"])")
//            print("latitude \(item["latitude"])")
//            print("longitude \(item["longitude"])")
//            
//            print("city \(item["city"])")
//            print("state \(item["state"])")
//            print("zip \(item["zip"])")
//            print("phone \(item["phone"])")
//            print("clinicHours \(item["clinicHours"])")
//            print("pharmacyHours \(item["pharmacyHours"])")
//            print("description \(item["description"])")
//            print("transportation \(item["transportation"])")
//        }
        
        let locations = locationDictionaries.map() {
            Location(dictionary: $0)!
        }
        
//        var locations:[Location]
//        if let locationDictionaries: [[String : Any]] = JSONDictionary {
//            locations =  locationDictionaries.map() {
//                Location(dictionary: $0)!
//            }
//        } else {
//            let locationDictionaries = JSONDictionary
//
//            locations = locationDictionaries.map() {
//                Location(dictionary: $0)!}
//        }
        
        return locations
    }
    
}
