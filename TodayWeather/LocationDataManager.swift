//
//  LocationDataManager.swift
//  TodayWeather
//
//  Created by Israel Berezin on 3/12/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import CoreData
import CoreLocation
import Combine

class LocationDataManager: ObservableObject {
    
    private let seviceAPI: SeviceAPI = SeviceAPI()
    
    private var cancellable: AnyCancellable?

    private var publishers = [AnyPublisher<Forecasts, Error>]()
    
    @Published var forecastsArrayVM: ForecastsDaysListVM?
    
    @Published var city :City = City(id: 1, city: "Loadind...", imageName: "jerusalem", state: "israel", coordinates: Coordinates(latitude: 0.0, longitude: 0.0))
    
    var locationService : LocationService? = nil
    
    func loadData() {
                    
        self.locationService = LocationService(){ locations in
            self.didUpdateLocations(locations: locations)
        }
        
    }
    
    func didUpdateLocations(locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = locations.first?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        locationManager.stopUpdatingLocation()
        self.lookUpCurrentLocation(latitude: CLLocationDegrees(locValue.latitude), longitude: CLLocationDegrees(locValue.longitude)) { (placemark) in
            self.city = City(id: 1, city: "", imageName: "jerusalem", state: "", coordinates: Coordinates(latitude: locValue.latitude, longitude: locValue.longitude))
        
            if let placemark = placemark{
                let letString = String(format:"%.3f", locValue.latitude)
                let longString = String(format:"%.3f", locValue.longitude)

                self.city.city = placemark.locality ?? "\(letString) , \(longString)"
                self.city.state = placemark.country ?? ""
            }
            
            if let forecast = self.loadCurrentLocationFromDB(city: self.city){
                self.forecastsArrayVM = forecast

            }else{
                let publisher = self.seviceAPI.loadWeatherToCity(self.city)
                
                self.cancellable = publisher.sink(receiveCompletion: { _ in }, receiveValue: { forecasts in
                    
                    if forecasts.response != nil && forecasts.response!.count > 0{
                        self.forecastsArrayVM = ForecastsDaysListVM(forecasts: forecasts.response.map({$0})!)
                        DBManger.shared.saveCityInDB(city: self.city, forcaset: (forecasts.response?.first)!)
                    }
                })

            }


        }
    }

    /*
     @property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
     @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
     @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
     @property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
     @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
     @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
     @property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
     @property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
     @property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg. US
     @property (nonatomic, readonly, copy, nullable) NSString *country; // eg. United States
     @property (nonatomic, readonly, copy, nullable) NSString *inlandWater; // eg. Lake Tahoe
     @property (nonatomic, readonly, copy, nullable) NSString *ocean; // eg. Pacific Ocean
     @property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *areasOfInterest; // eg. Golden Gate Park

     */
    func lookUpCurrentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        let lastLocation = CLLocation(latitude: latitude, longitude: longitude)
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
    }

    
    func loadCurrentLocationFromDB(city : City) -> ForecastsDaysListVM?{
        if let dbCity =  DBManger.shared.getCityByCityName("1"){
            return(dbCity)
        }else{
            return nil
        }
    }
}


