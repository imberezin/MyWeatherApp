//
//  DBManger.swift
//  SwiftUIWeatherDB
//
//  Created by Israel Berezin on 3/11/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import SwiftUI
import Combine

class DBManger {
    
    static let shared = DBManger(moc: NSManagedObjectContext.current)
    
    var managedObjectContext: NSManagedObjectContext
       
    private init(moc: NSManagedObjectContext) {
        self.managedObjectContext = moc
    }
    
    
    func deleteAllCiteis(){
        do {
            let orderRequest: NSFetchRequest<Cities> = Cities.fetchRequest()
            let cities = try self.managedObjectContext.fetch(orderRequest)

            for managedObjectData in cities {
//                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                self.managedObjectContext.delete(managedObjectData)
//                }
            }
        } catch let error as NSError {
                   print(error)
        }
    }

    func fatchAllCiteis() -> [Cities]{
        var cities = [Cities]()
        let orderRequest: NSFetchRequest<Cities> = Cities.fetchRequest()
        
        do {
            cities = try self.managedObjectContext.fetch(orderRequest)
        } catch let error as NSError {
            print(error)
        }
        return cities
    }
    
    func getAllCiteis() -> [ForecastsDaysListVM]{
        
       // self.deleteAllCiteis()
        
        var forecastsDaysListVM = [ForecastsDaysListVM]()
        
        let cities = self.fatchAllCiteis()
        
        if cities.count > 0{
            let first = cities.first
            if self.checkIfDBObjectExpierd(city: first!){
                self.deleteAllCiteis()
                forecastsDaysListVM.removeAll()
                return forecastsDaysListVM
            }else{
                for city in cities{
                    let oneForecastsDaysListVM = ForecastsDaysListVM(cities: city)
                    forecastsDaysListVM.append(oneForecastsDaysListVM)
                }
            }
        }
        
        return forecastsDaysListVM
    }
    
    func checkIfDBObjectExpierd(city: Cities) -> Bool{
        var isExpierd = false
        let now = Date()
        let dbDate = city.updateTime
        let diff = now.timeIntervalSince1970 - dbDate!.timeIntervalSince1970
        print("diff = \(diff)")
        // if diff > 4 hours, isExpierd = true
        if diff - (3600.0 * 4.0) > 0{
            isExpierd = true
        }
        return isExpierd
    }
    
    func saveCityInDB(city: City, forcaset: Forecast){

        let cities = Cities(context: managedObjectContext)

        cities.id = Int32(city.id)
        cities.name = city.city
        cities.state = city.state
        cities.imageName = city.imageName
        cities.updateTime = Date()

        let citiesCoordinates = CitiesCoordinates(context: managedObjectContext)
        citiesCoordinates.latitude = city.locationCoordinate.latitude
        citiesCoordinates.longitude = city.locationCoordinate.longitude
        citiesCoordinates.city  = cities
        
        var preiods = [WeatherPeriod]()
        for preiod in forcaset.periods!{
            let weatherPeriod = WeatherPeriod(context: managedObjectContext)
            weatherPeriod.id  = UUID()
            weatherPeriod.cloudsCoded = preiod.cloudsCoded ?? ""
            weatherPeriod.dateTimeISO = preiod.dateTimeISO
            weatherPeriod.humidity = preiod.humidity ?? 0
            weatherPeriod.icon = preiod.icon ?? ""
            weatherPeriod.loolLikeC = preiod.feelslikeC ?? 0
            weatherPeriod.sky = preiod.sky ?? 0
            weatherPeriod.tempAvgC = preiod.avgTempC ?? 0
            weatherPeriod.tempMaxC = preiod.maxTempC ?? 0
            weatherPeriod.tempMinC = preiod.minTempC ?? 0
            weatherPeriod.uvi = preiod.uvi ?? 0
            weatherPeriod.weather = preiod.weather ?? ""
            weatherPeriod.windGustKPH = preiod.windGustKPH ?? 0
            weatherPeriod.city = cities
            preiods.append(weatherPeriod)
        }
        
        cities.coordinates = citiesCoordinates
        cities.periods = NSOrderedSet.init(array: preiods)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
