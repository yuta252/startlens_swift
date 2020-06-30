//
//  LocationViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/25.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationListDelegate{
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

        language = UserDefaults.standard.string(forKey: "language") ?? "ja"
        locationManager = CLLocationManager()
        setupUI()
    }
    
    
    @IBAction func currentLocationAction(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied{
            showAlert()
        }else if status == .authorizedWhenInUse{
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            // インジケーター表示
            indicator.startAnimating()
            indicator.style = .large
            indicator.hidesWhenStopped = true
            indicator.color = ThemeColor.main
            // 遅延処理
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.delegate?.locationData(key: self.locationKey, label: self.locationLabel)
                self.indicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.defaultLocationData(key: "all", label: "場所")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        getCurrentLocationText.setTitle("locationCurrent".localized, for: .normal)
        deleteButton.setTitle("deleteButtonTitle".localized, for: .normal)
    }
    
    func showAlert(){
        // アラートを表示する
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定>プライバシー>位置情報サービスから設定を変更してください。"
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
        convert(lat: latitude!, lon: longitude!)
        print("ロケーション情報をコンバートしました")
    }
    
    // 逆ギオコーディング処理
    func convert(lat: CLLocationDegrees, lon:CLLocationDegrees){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: language)) { (placeMark, error) in
            if let placeMark = placeMark{
                if let pm = placeMark.first{
                    if pm.administrativeArea != nil || pm.locality != nil{
                        self.locationLabel = pm.locality!
                        self.locationKey = pm.locality!
                    }else{
                        self.locationLabel = pm.name!
                        self.locationKey = pm.name!
                    }
                }
            }
        }
        print("逆ジオコーデング")
    }
    
}
