//
//  ForecastsVM.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/26/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


struct ForecastsVM: Identifiable {
    
    let id = UUID()
    
    var period: Period
    
//    var placeCity: String{
//        return "" //forecast.place?.city ?? ""
//    }
//    var placeCountry: String{
//        return "" //forecast.place?.country ?? ""
//    }
    
//    var long: Double{
//        return forecast.loc?.long ?? 0
//    }
//
//    var lat: Double{
//          return forecast.loc?.lat ?? 0
//    }
//
    var tempMaxC: Double{
        return self.period.maxTempC ?? 0
    }
    
    var tempMinC: Double{
        return self.period.minTempC ?? 0
    }
    
    var tempAvgC: Double{
        return self.period.avgTempC ?? 0
    }
    
    // String(format:"%.1f",
    
    var loolLikeC: String{
        let doubleValue = self.period.feelslikeC ?? 0
        return String(format:"%.1f", doubleValue)
    }
    
    var tempStrMinC: String{
        let doubleValue = self.tempMinC
        return String(format:"%.1f", doubleValue)
    }
    
    var tempStrMaxC: String{
        let doubleValue = self.tempMaxC
        return String(format:"%.1f", doubleValue)
    }

    var weatherPhrase:String {
        self.period.weather ?? ""
    }
    
    var weatherPrimary:String{
        "" //forecast.periods?.first?.summary?.weather?.primary ?? ""
    }
    
    var weatherIcon:String{
        //.png
        if let icon = self.period.icon{
            let parsed = icon.replacingOccurrences(of: ".png", with: "")
            return parsed
        }
        return ""
    }

    
    var windAvgKPH:String{
        return String("\(self.period.windGustKPH ?? 0)")
    }
    
    
    var humidity: String{
        // humidity
        let doubleValue = self.period.humidity ?? 0
        return String(format:"%.1f", doubleValue)
    }
    
    var skyCover: String{
        let doubleValue = self.period.uvi ?? 0
        return String(format:"%.1f", doubleValue)
    }
    
    var visibility: String{
        let doubleValue = self.period.uvi ?? 0
        return String(format:"%.1f", doubleValue)
    }

    
    var sky: String {
        if let skyCode = period.cloudsCoded{
            if skyCode == "CL"{
                return "Clear"
            }
            if skyCode == "FW"{
                return "Mostly Sunny"
            }
            if skyCode == "SC"{
                return "Partly Cloudy"
            }
            if skyCode == "BK"{
                return "Mostly Cloudy"
            }
            if skyCode == "OV"{
                return "Cloudy"
            }
        }
        return "Clear"
    }

}

/*
 sky: code
 CL    Clear    Cloud coverage is 0-7% of the sky.
 FW    Fair/Mostly sunny    Cloud coverage is 7-32% of the sky.
 SC    Partly cloudy    Cloud coverage is 32-70% of the sky.
 BK    Mostly Cloudy    Cloud coverage is 70-95% of the sky.
 OV    Cloudy/Overcast    Cloud coverage is 95-100% of the sky.
 */
