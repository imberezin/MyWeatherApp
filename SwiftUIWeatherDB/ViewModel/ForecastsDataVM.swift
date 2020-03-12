//
//  ForecastsDataVM.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/26/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import Combine
import MapKit
import CoreLocation


class ForecastsDataVM: ObservableObject {
    
    @Published var forecastsArrayVM = [ForecastsDaysListVM]()

    @Published var forecastsAnnotations: [MKAnnotation] = [MKAnnotation]()
    
//    @Published var forecastsWeekVM = [ForecastsVM]()

    let cityData: [City] = load("Cities.json")
    
    private let seviceAPI: SeviceAPI = SeviceAPI()
    
    private var cancellable: AnyCancellable?

    private var forecasts = [Forecasts]()

    private var publishers = [AnyPublisher<Forecasts, Error>]()

    private var cityNames: [String] = [String]()
    // ["tel aviv","Jerusalem","Lod","Modiin","Netanya","Haifa","Tiberias","Ashdod","Beersheba","zefat","Nahariyya","Ashqelon"]

    private let locationManager = CLLocationManager()

    func loadForecastsData() {
        
        
        self.loadloadForecastsDatafromDB()

    }

    func loadloadForecastsDatafromDB(){
        
        
        if cityData.count == 0{
            return
        }

        if self.forecastsArrayVM.count > 2{
                   return
        }
        
        self.cityNames = cityData.map({ (city) -> String in
            return "\(city.city),\(city.state)"
        })
        print(cityNames)

        self.forecastsArrayVM.removeAll()
        
        let data: [ForecastsDaysListVM] =  DBManger.shared.getAllCiteis()
        if data.count == 0{
            self.loadloadForecastsDatafromRemote()
        }else{
            self.forecastsArrayVM = data
        }
    }
  
    func loadloadForecastsDatafromRemote(){
        
 
                
        // For use when the app is open
        self.locationManager.requestWhenInUseAuthorization()
        self.publishers.removeAll()
        self.forecasts.removeAll()
        
        
//        if cityData.count == 0{
//            return
//        }
        
        if self.forecasts.count > 2{
            return
        }
        
        
//        self.cityNames = cityData.map({ (city) -> String in
//            return "\(city.city),\(city.state)"
//        })
//        print(cityNames)

//        for city in self.cityNames{
//            let publisher = self.seviceAPI.loadWeatherToLocation(city)
//            publishers.append(publisher)
//        }
  
        for city in self.cityData {
            let publisher = self.seviceAPI.loadWeatherToCity(city)
            publishers.append(publisher)
        }

        self.cancellable = Publishers.MergeMany(publishers)
            .compactMap { $0 }
            .catch { _ in
                Just(Forecasts.placeholder) }
            .sink(receiveCompletion: { _ in
                
                self.forecastsArrayVM.removeAll()
                
                 var tempForecasts = [Forecasts]()

                for (index, city) in self.forecasts.enumerated(){
//                    print("\n\n--=======\(self.cityNames[index])=======--\n\(city)")
            
                    if city.response != nil && city.response!.count > 0 {
                        tempForecasts.append(city)
                    }
                    DBManger.shared.saveCityInDB(city: self.cityData[index], forcaset: (city.response?.first)!)

                }
                print("\n\nself.forecasts.count = \(self.forecasts.count)\n  tempForecasts.count = \(tempForecasts.count)\n self.cityNames.count = \(self.cityNames.count)\n")
                

                self.forecastsArrayVM = tempForecasts.map{ ForecastsDaysListVM(forecasts: ($0.response)!)}
                
                
                
            }, receiveValue: { result in
                self.forecasts.append(result)
        })
        

        
    }
    
    func cityNameByIndex(_ index: Int) -> String{
        if index < self.cityNames.count{
            let name = self.cityNames[index]
            return name.replacingOccurrences(of: ",Israel", with: "")
        }
        return "Tel"
    }
    
    func buildAnnotations(){
        
        var tempAnnotations = [MKAnnotation]()
        for (index, forecast) in self.cityData.enumerated() {
            let forecastsVMObject = self.forecastsArrayVM[index].getFirstItem() as ForecastsVM

            let annotation = WeatherAnnotation(coordinate: forecast.locationCoordinate)
            annotation.title = forecast.city
            annotation.subtitle = "Israel"
            annotation.arrayIndex = index
            annotation.imageName = forecastsVMObject.weatherIcon.lowercased()
            annotation.sky = forecastsVMObject.sky
            tempAnnotations.append(annotation)
        }
        self.forecastsAnnotations = tempAnnotations
    }
    
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
    
}
