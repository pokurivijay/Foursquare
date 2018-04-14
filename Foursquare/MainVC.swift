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
import SwiftyJSON

class MainVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var venusTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var tableDataArray = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "VenusTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "hi"
        
        
        return cell
        
    }
    
    func getDataFromFoursquare(lat: String, long: String){
        
        let json = JSON(["name":"Jack", "age": 25])
        if let name = json["address"].string {
            // Do something you want
        } else {
            print(json["address"].error!) // "Dictionary["address"] does not exist"
        }
        
        let foursquareUrl = "https://api.foursquare.com/v2/venues/search?ll=\(lat),\(long)&oauth_token=GX153OQLQ23RV0U2LAVLBGGIWJ4ZXK1AH015KZD0XGNECVVJ&v=20180414"
        
        Alamofire.request(foursquareUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(String(describing: json["meta"]["code"].string))")
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createMapView()// Create and Add MapView to our main view
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        determineCurrentLocation()
//    }
    
    func createMapView()
    {
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        getDataFromFoursquare(lat: String(userLocation.coordinate.latitude), long: String(userLocation.coordinate.longitude))
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Your location"
        mapView.addAnnotation(myAnnotation)
    }
    
    
    
    
    
    

    @IBAction func updateCurrentLocation(_ sender: Any) {
        
        determineCurrentLocation()//getting the current location
    }
    
    func determineCurrentLocation()
    {
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

