//
//  ViewController.swift
//  NotificationTutorial
//
//  Created by User on 4/19/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import UserNotifications
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var dateTimeLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTimeLabel.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        self.locationManager.delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "You are near by our STK Clinic"
        content.body = "Location Home: \(DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium))"
        content.sound = UNNotificationSound.default()


        let center = CLLocationCoordinate2D(latitude: 37.799934, longitude: -122.408724)
        let region = CLCircularRegion(center: center, radius: 3, identifier: "STK")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        //mapView.camera.centerCoordinate = center
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        locationLabel.text = "latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)"
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        print("Date & Time: \(DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
}

/*
 //
 //  ViewController.swift
 //  NotificationTutorial
 //
 //  Created by User on 4/19/18.
 //  Copyright © 2018 User. All rights reserved.
 //
 
 import UIKit
 import UserNotifications
 //import MapKit
 import CoreLocation
 
 class ViewController: UIViewController, CLLocationManagerDelegate {
 
 // MARK: - Declaração do Location Manager
 let locationManager = CLLocationManager()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // MARK: - Declarar o delegate de locationManager
 locationManager.delegate = self
 
 // MARK: - Pedir permissão para enviar notificações
 UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: {
 (granted, error) in
 if (granted) {
 print("\nYou have permission to send notifications\n")
 } else {
 print("\nPermission to send notifications denied\n")
 }
 
 // MARK: - Request permission to enable geolocation
 self.locationManager.requestWhenInUseAuthorization()
 
 })
 }
 
 override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 
 //determineMyCurrentLocation()
 //locationManager.requestWhenInUseAuthorization()
 }
 
 func determineMyCurrentLocation() {
 //locationManager = CLLocationManager()
 locationManager.delegate = self
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 locationManager.requestAlwaysAuthorization()
 
 if CLLocationManager.locationServicesEnabled() {
 locationManager.startUpdatingLocation()
 //locationManager.startUpdatingHeading()
 }
 }
 
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 let userLocation:CLLocation = locations[0] as CLLocation
 
 // Call stopUpdatingLocation() to stop listening for location updates,
 // other wise this function will be called every time when user location changes.
 
 // manager.stopUpdatingLocation()
 
 print("user latitude = \(userLocation.coordinate.latitude)")
 print("user longitude = \(userLocation.coordinate.longitude)")
 }
 
 
 // MARK: - Create method of CLLocationManagerDelegate to request notification only after receiving required permissions
 func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
 print("in locationManager: CLAuthorizatioStatus")
 switch status {
 case .authorizedWhenInUse:
 print("\nYou are allowed to use geolocation services\n")
 
 // MARK: - Criar a notificação
 let notificationContent: UNMutableNotificationContent = UNMutableNotificationContent()
 notificationContent.body = "You came!"
 
 // MARK: - Criar o gatilho de notificação a partir das cordenadas desejadas
 let center = CLLocationCoordinate2D(latitude: 37.7980852807502, longitude: -122.403305698121) // Atualizar com latitude e longitude desejadas
 let region = CLCircularRegion(center: center, radius: 1.0, identifier: "UPM") // Atualizar com raio e identificador desejados
 region.notifyOnEntry = true
 region.notifyOnExit = true
 let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
 
 // MARK: - Criar a requisição de notificação e mandá-la para o NotificationCenter do iOS
 let request = UNNotificationRequest(identifier: "notificacaoLocalizacao", content: notificationContent, trigger: trigger)
 UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
 print("\nAll pending notifications have been removed\n")
 UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
 if (error == nil) {
 print("\nNotification successfully requested\n")
 } else {
 print("\nNotification could not be requested\n")
 }
 })
 
 break
 
 case .denied:
 print("\nPermission to use geolocation services denied\n")
 break
 
 default:
 print("default")
 break
 }
 }
 
 /*
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 
 //determineMyCurrentLocation()
 }
 
 func determineMyCurrentLocation() {
 locationManager = CLLocationManager()
 locationManager.delegate = self
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 locationManager.requestAlwaysAuthorization()
 
 if CLLocationManager.locationServicesEnabled() {
 locationManager.startUpdatingLocation()
 //locationManager.startUpdatingHeading()
 }
 }
 
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 let userLocation:CLLocation = locations[0] as CLLocation
 
 // Call stopUpdatingLocation() to stop listening for location updates,
 // other wise this function will be called every time when user location changes.
 
 // manager.stopUpdatingLocation()
 
 print("user latitude = \(userLocation.coordinate.latitude)")
 print("user longitude = \(userLocation.coordinate.longitude)")
 }
 
 func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
 {
 print("Error \(error)")
 }
 */
 
 }
 

 
*/
