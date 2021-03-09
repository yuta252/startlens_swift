//
//  LocationViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/25.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationListDelegate {
    func locationData(key: String, label: String)
    func defaultLocationData(key: String, label: String)
}

class LocationViewController: UIViewController {

    var delegate: LocationListDelegate?
    var locationLabel = String()
    var locationKey = String()
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var language = String()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var getCurrentLocationText: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        language = Language.getLanguage()
        locationManager = CLLocationManager()

        setupUI()
    }
    
    @IBAction func currentLocationAction(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            startIndicator()
            // Delay processing until location manager update new location
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.delegate?.locationData(key: self.locationKey, label: self.locationLabel)
                self.stopIndicator()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.defaultLocationData(key: "all", label: "searchLocationPlace".localized)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        getCurrentLocationText.setTitle("locationCurrent".localized, for: .normal)
        deleteButton.setTitle("deleteButtonTitle".localized, for: .normal)
    }
    
    func startIndicator() {
        indicator.startAnimating()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.color = ThemeColor.main
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
    }
    
    func showAlert(){
        // Show alert to permit to get location info
        let alertTitle = "locationAlertTitle".localized
        let alertMessage = "locationAlertMessage".localized
        let alert:UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "okButtonText".localized, style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}

extension LocationViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        latitude = location?.coordinate.latitude
        longitude = location?.coordinate.longitude
        print("Action: locationManager, Message: Start to update location manager, Latitude: \(latitude ?? 0.0), Longitude: \(longitude ?? 0.0)")
        convert(lat: latitude!, lon: longitude!)
        print("Action: locationManager, Message: Finish to update location manager")
    }
    
    // Reverse GEO coding
    func convert(lat: CLLocationDegrees, lon:CLLocationDegrees){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        print("Action: convert, Message: Start to convert location data")
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: language)) { (placeMark, error) in
            if let placeMark = placeMark {
                if let pm = placeMark.first {
                    if pm.administrativeArea != nil || pm.locality != nil {
                        self.locationLabel = pm.locality!
                        self.locationKey = pm.locality!
                    } else {
                        self.locationLabel = pm.name!
                        self.locationKey = pm.name!
                    }
                }
            }
            print("Action: convert, Message: Converting location data to label, LocationLabel: \(self.locationLabel)")
        }
        print("Action: convert, Message: Finish to convert location data")
    }
}

