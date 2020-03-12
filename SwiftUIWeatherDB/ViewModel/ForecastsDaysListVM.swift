//
//  ForecastsDaysListVM.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/8/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation

import Foundation
import Combine
import SwiftUI


struct ForecastsDaysListVM: Identifiable {
    
    let id = UUID()

    var forecasts: [Forecast]
    
    var forecastsDB: [Cities]?

    var forecastsVM: [ForecastsVM] = [ForecastsVM]()
    
    
    init(cities: Cities) {
        self.forecasts = [Forecast(loc: nil, interval: "", periods: nil, profile: nil)]
        print("DB cities.name =\(cities.name)")
        
        
        cities.periods!.enumerateObjects { (elem, idx, stop) -> Void in
            var period = Period()
            if let p = elem as? WeatherPeriod{
                period.icon = p.icon
                period.avgTempC = p.tempAvgC
                period.cloudsCoded = p.cloudsCoded
                period.dateTimeISO = p.dateTimeISO
                period.humidity = p.humidity
                period.feelslikeC = p.loolLikeC
                period.sky = p.sky
                period.maxTempC = p.tempMaxC
                period.minTempC = p.tempMinC
                period.uvi = p.uvi
                period.weather = p.weather
                period.windGustKPH = p.windGustKPH
                
            }
            let forecastsVM = ForecastsVM(period: period)
            self.forecastsVM.append(forecastsVM)
        }
        
        
//        for p in cities.periods!{
//
//            let period = Period()
//            period.avgTempC = p.self
//            let forecastsVM = ForecastsVM(period: period)
//
//        }

    }

    init(forecasts: [Forecast]) {
        self.forecasts = forecasts
//        self.forecastsVM = forecasts.map{ForecastsVM(forecast: ($0))}
        let f = forecasts.first
        
        for p in f!.periods!{
            let forecastsVM = ForecastsVM(period: p)
            self.forecastsVM.append(forecastsVM)
        }
       // self.forecastsVM = f?.periods.map({ForecastsVM(period: $0)})
        
    }

    func getItemByIndex(_ index: Int) -> ForecastsVM?{
        if self.itemByIndexExist(index){
            return self.forecastsVM[index]
        }
        return nil
    }
    
    func itemByIndexExist(_ index: Int) -> Bool{
        if index < self.forecastsVM.count {
            return true
        }
        return false
    }
    
    func getFirstItem() -> ForecastsVM{
        return self.forecastsVM.first!
    }

}

