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
        
        //location = LocationData(name: "Stockton", address: "1520 Stockton St.", description: "Our main clinic on 1520 Stockton Street in Chinatown/North Beach", image: #imageLiteral(resourceName: "locationsStockton"), latitude: 37.799934, longitude: -122.408724)
        if ModelStore.shared.allLocations.count <= 0 {
            ModelStore.shared.allLocations.append(LocationData(name: "Stockton", address: "1520 Stockton St.", description: "Our main clinic on 1520 Stockton Street in Chinatown/North Beach", image: #imageLiteral(resourceName: "locationsStockton"), latitude: 37.799934, longitude: -122.408724))
            ModelStore.shared.allLocations.append(LocationData(name: "San Bruno", address: "2574 San Bruno Ave.", description: "Our 2574 San Bruno clinic in the Portola District opened in December 2009", image: #imageLiteral(resourceName: "locationsPortola"), latitude: 37.729605, longitude: -122.404497))
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
        locationImageView.image = location.image
        
        ModelStore.shared.selectedLocation = ModelStore.shared.allLocations[indexPath.row]
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(ModelStore.shared.allLocations[indexPath.row].latitude), longitude: CLLocationDegrees(ModelStore.shared.allLocations[indexPath.row].longitude)), span: MKCoordinateSpan(latitudeDelta: 0.0009, longitudeDelta: 0.0009))
        mapView.setRegion(region, animated: true)
        
    }

    @IBAction func segueToLocationDetailVC (_ sender: Any) {
        print("locatoin Tap gesture")
        let c = self.storyboard!.instantiateViewController(withIdentifier: "LocationDetailVC") as! LocationDetailVC
        
        self.navigationController!.pushViewController(c, animated: true)
    }
}
