//
//  GMapVC.swift
//  NEMS
//
//  Created by User on 5/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class GMapVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapSubVC: UIView!
    var gmsView: GMSMapView!
    var locationManager = CLLocationManager()
    
    //var gmRect: CGRect!
    var camera: GMSCameraPosition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         camera = GMSCameraPosition.camera(withLatitude: Double(ModelStore.shared.selectedLocation.latitude!)!, longitude: Double(ModelStore.shared.selectedLocation.longitude!)!, zoom: 16.0)
        
        //set google map size to have the same size as subView "mapView".
        gmsView = GMSMapView.map(withFrame: mapSubVC.bounds, camera: camera)
        //print("view: \(view.bounds), subView: \(mapSubVC.bounds), gmRect: \(gmRect)")
        gmsView.delegate = self
        gmsView?.isMyLocationEnabled = true
        gmsView.settings.myLocationButton = true
        //gmsView.settings.compassButton = true
        //gmsView.settings.zoomGestures = true
        
        mapSubVC.addSubview(gmsView)
        
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.stopUpdatingLocation()
            
            drawDirectionPath(startLoc: locationManager.location!,endLoc: CLLocation(latitude: camera.target.latitude, longitude: camera.target.longitude), directionMode: "driving")
        } else { print("Location Services is Disabled on the Device")}
        
        
        
        //Greate map maker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(ModelStore.shared.selectedLocation.latitude!)!, longitude: Double(ModelStore.shared.selectedLocation.longitude!)!)
        marker.title = ModelStore.shared.selectedLocation.name
        marker.icon = #imageLiteral(resourceName: "Location_Marker")
        marker.map = gmsView

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //gmsView = GMSMapView.map(withFrame: mapSubVC.bounds, camera: camera)
        //mapSubVC.addSubview(gmsView)
        gmsView.bounds = mapSubVC.bounds
        //print("view: \(view.bounds), subView: \(mapSubVC.bounds)")
        
    }
   

    //MARK: - function to create direction path from loc_1 to loc_2
    func drawDirectionPath(startLoc: CLLocation, endLoc: CLLocation, directionMode: String) {
        //mode: driving, walk....
        //print("in drawDirectionPath")
        let origin = "\(startLoc.coordinate.latitude),\(startLoc.coordinate.longitude)"
        
        let destination = "\(endLoc.coordinate.latitude),\(endLoc.coordinate.longitude)"
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&travelmode=\(directionMode)")!
        
        let url2 = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(origin)&destination=\(destination)&travelmode=\(directionMode)")!
        
        print("url: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            //parse the Data into JSON Object
            let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))

            guard let JSONDictionary = json as? [String:Any] else {
                assertionFailure("Failed to parse data. data.length: \(data?.count)")
                return
            }

            
            DispatchQueue.main.async {
                let routes = JSONDictionary["routes"] as! [[String:Any]]
                print("routes: \(routes)")
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"] as! [String:Any]
                    let points = routeOverviewPolyline["points"]
                    //print("routeOverviewPolyline: \(routeOverviewPolyline)")
                    //print("points: \(points)")
                    let path = GMSPath.init(fromEncodedPath: points as! String)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.gmsView
                }
                
                //UIApplication.shared.openURL(url2)  //this line launch Google map app
                
            }
            
        }
        
        task.resume()
    
    }

    static private func prettyPrint(_ JSONObject: Any) {
        let prettyData = try! JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted)
        let prettyString = String(data: prettyData, encoding: String.Encoding.utf8)
        print(prettyString ?? "No String Available")
    }
}


//https://maps.googleapis.com/maps/api/directions/json?origin=37.799934,-122.408724&destination=37.7971004,-122.4097&mode=driving
