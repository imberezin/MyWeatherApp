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
       
    init(moc: NSManagedObjectContext) {
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
    func getCityByCityName(_ cityId: String) -> ForecastsDaysListVM?{
        var forecastsDaysListVM : ForecastsDaysListVM?
        
        let userFetchRequest = NSFetchRequest<Cities>(entityName: "Cities")
        
        //4) filter using this predicate
        userFetchRequest.predicate = NSPredicate(format: "id == %@", cityId)
        
        do {
            //5) Execute fetchh request
            let cities = try managedObjectContext.fetch(userFetchRequest)
            
            //6 Print Users count
            print("Users Count \(cities.count)")
            
            if cities.count > 0{
                let first = cities.first
                if self.checkIfDBObjectExpierd(city: first!){
                    self.deleteAllCiteis()
                    return forecastsDaysListVM
                }else{
                    forecastsDaysListVM = ForecastsDaysListVM(cities: first!)
                }
            }

            
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return forecastsDaysListVM

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
class DBPersistentManger {

static let shared = DBPersistentManger()

        // MARK: - Core Data stack

         lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
            */
            let container = NSPersistentContainer(name: "SwiftUIWeatherDB")
            let storeURL = URL.storeURL(for: "group.Berezin", databaseName: "Coyote")
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [storeDescription]

            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })

            return container
        }()

        // MARK: - Core Data Saving support

        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    }

    public extension URL {

        /// Returns a URL for the given app group and database pointing to the sqlite database.
        static func storeURL(for appGroup: String, databaseName: String) -> URL {
            guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
                fatalError("Shared file container could not be created.")
            }

            return fileContainer.appendingPathComponent("\(databaseName).sqlite")
        }
    }

