//
//  Location קרהןבק.swift
//  TodayWeather
//
//  Created by Israel Berezin on 3/15/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import CoreLocation
import Combine

class LocationService: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    public var completion: (([CLLocation]) -> Void)?
    
    init(completion: @escaping (([CLLocation]) -> Void)){
        
        super.init()
        self.completion = completion
        
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        self.completion!(locations)
    }
    
}
