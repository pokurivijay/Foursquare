//
//  MainVC.swift
//  Foursquare
//
//  Created by Vijay on 12/04/18.
//  Copyright © 2018 VJ. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MainVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    //var mapView: MKMapView!
    @IBOutlet weak var mapView: MKMapView!
    
    var foursquareUrl = "https://api.foursquare.com/v2/venues/search?ll=40.7484,-73.9857&oauth_token=GX153OQLQ23RV0U2LAVLBGGIWJ4ZXK1AH015KZD0XGNECVVJ&v=20180414"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        getDataFromFoursquare()
        
    }
    
    func getDataFromFoursquare(){
        
        Alamofire.request(foursquareUrl).responseJSON { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and Add MapView to our main view
        createMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    func createMapView()
    {
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
    }
    
    func determineCurrentLocation()
    {

        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Your location"
        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

