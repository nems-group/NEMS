//
//  LocationVC.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation

class LocationVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: UIView!
    
    var locationManager = CLLocationManager()
    var gmsView: GMSMapView!
    var camera: GMSCameraPosition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        ModelStore.shared.allLocations = self.locationFromData(LocalData.shared.json)
        
        tableView.reloadData()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //always select the 1st row
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
        
        camera = GMSCameraPosition.camera(withLatitude: Double(ModelStore.shared.allLocations[indexPath.row].latitude!)!, longitude: Double(ModelStore.shared.allLocations[indexPath.row].longitude!)!, zoom: 16.00)
        
        //set google map size to have the same size as subView "mapView".
        gmsView = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        
        gmsView.settings.scrollGestures = false     //disable map Pan
        gmsView.settings.zoomGestures = false       //disable map Zoom
        gmsView?.isMyLocationEnabled = true         //enable my location
        gmsView.clear()
        
        mapView.addSubview(gmsView)
        
        
        //Greate map maker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(ModelStore.shared.selectedLocation.latitude!)!, longitude: Double(ModelStore.shared.selectedLocation.longitude!)!)
        marker.title = ModelStore.shared.selectedLocation.name
        marker.icon = #imageLiteral(resourceName: "NEMS_icon")
        marker.groundAnchor = CGPoint(x:0.5, y:0.8)
        marker.map = gmsView
        
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
        
        return locations
    }
    

    @IBAction func tapGestureFn(_ sender: Any) {

        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.stopUpdatingLocation()
            
            let startLoc = locationManager.location!
            let endLoc = CLLocation(latitude: Double(ModelStore.shared.selectedLocation.latitude!)!, longitude: Double(ModelStore.shared.selectedLocation.longitude!)!)
            let origin = "\(String(describing: startLoc.coordinate.latitude)),\(String(describing: startLoc.coordinate.longitude))"
            
            let destination = "\(endLoc.coordinate.latitude),\(endLoc.coordinate.longitude)"
            let url = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(origin)&destination=\(destination)&travelmode=driving")!
            UIApplication.shared.open(url, options: [:])  //this line launch Google map app

        } else { print("Location Services is Disabled on the Device")}
    
    }
    
}
