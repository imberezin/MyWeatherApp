//
//  File.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/24/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation

struct Forecasts: Decodable {
    public var response: [Forecast]?
    public var error: ForecastsError?
    public var success: Bool?

    static var placeholder: Forecasts {
        return Forecasts()
    }

}
public struct ForecastsError: Codable, Error {
    public var code, errorDescription: String?
}


struct Forecast: Decodable {
    public var loc: LOC?
    public var interval: String?
    public var periods: [Period]?
    public var profile: Profile?

}



public struct LOC: Codable {
    public var long, lat: Double?
}

public struct Profile: Codable {

    public var tz: String?
    public var elevM: Double?
    public var elevFT: Double?
    public var hasPrecip: Bool?
}

public struct Period: Codable {
    public var timestamp: Double?
    public var validTime, dateTimeISO: Date?
    public var maxTempC, maxTempF, minTempC, minTempF: Double?
    public var avgTempC, avgTempF: Double?
    public var tempC, tempF: Double?
    public var pop, precipMM, precipIN: Double?
    public var iceaccum, iceaccumMM, iceaccumIN: Double?
    public var maxHumidity, minHumidity, humidity, uvi: Double?
    public var pressureMB: Double?
    public var pressureIN: Double?
    public var sky, snowCM, snowIN : Double?
    public var feelslikeC: Double?
    public var feelslikeF, minFeelslikeC, minFeelslikeF, maxFeelslikeC: Double?
    public var maxFeelslikeF, avgFeelslikeC, avgFeelslikeF, dewpointC: Double?
    public var dewpointF, maxDewpointC, maxDewpointF, minDewpointC: Double?
    public var minDewpointF, avgDewpointC, avgDewpointF, windDirDEG: Double?
    public var windDir: String?
    public var windDirMaxDEG: Double?
    public var windDirMax: String?
    public var windDirMinDEG: Double?
    public var windDirMin: String?
    public var windGustKTS, windGustKPH, windGustMPH, windSpeedKTS: Double?
    public var windSpeedKPH, windSpeedMPH, windSpeedMaxKTS, windSpeedMaxKPH: Double?
    public var windSpeedMaxMPH, windSpeedMinKTS, windSpeedMinKPH, windSpeedMinMPH: Double?
    public var windDir80MDEG: Double?
    public var windDir80M: String?
    public var windDirMax80MDEG: Double?
    public var windDirMax80M: String?
    public var windDirMin80MDEG: Double?
    public var windDirMin80M: String?
    public var windGust80MKTS, windGust80MKPH, windGust80MMPH, windSpeed80MKTS: Double?
    public var windSpeed80MKPH, windSpeed80MMPH, windSpeedMax80MKTS, windSpeedMax80MKPH: Double?
    public var windSpeedMax80MMPH, windSpeedMin80MKTS, windSpeedMin80MKPH, windSpeedMin80MMPH: Double?
    public var weather: String?
//    public var weatherCoded: [String]?
    public var weatherPrimary, weatherPrimaryCoded, cloudsCoded, icon: String?
    public var solradWM2, solradMinWM2, solradMaxWM2: Double?
    public var isDay: Bool?
    public var sunrise: Double?
    public var sunriseISO: Date?
    public var sunset: Double?
    public var sunsetISO: Date?

}


//struct Forecast: Decodable {
//
//    public var id: String?
//    public var place: Place?
//    public var loc: LOC?
//    public var profile: Profile?
//    public var periods: [Period]?
//}
//
//public struct Place: Codable {
//    public var name, city, state, country: String?
//
//}
//


//
//public struct Period: Codable {
//    public var summary: Summary?
//}
//
//public struct Summary: Codable {
//public var timestamp: Double?
//public var dateTimeISO: Date?
//public var ymd: Double?
//public var range: Range?
//public var temp, dewpt: [String: Double?]?
//public var rh: Rh?
//public var pressure: [String: Double?]?
//public var visibility: [String: Double?]?
//public var wind: [String: Double?]?
//public var precip: Precip?
//public var weather: Weather?
//public var sky: Rh?
////public var solrad: Solrad?
////public var qc: Qc?
//public var spressure: [String: Double]??
////public var trustFactor: Qc?
//
//}
//
//
//// MARK: - Range
//public struct Range: Codable {
//    public var maxTimestamp: Double?
//    public var maxDateTimeISO: Date?
//    public var minTimestamp: Double?
//    public var minDateTimeISO: Date?
//    public var count: Double?
//}
//
//// MARK: - Precip
//public struct Precip: Codable {
//    public var totalMM, totalIN, count: Double?
//    public var trace: Bool?
//    public var traceCount, max24Hr, countMax24Hr, qCcode: Double?
//    public var qc: Double?
//    public var precipQc: Double?
//    public var method: String?
//}
//
//
//// MARK: - Rh
//public struct Rh: Codable {
//    public var max, min, avg, count: Double?
//    public var qc: Double?
//    public var coded: [String]?
//}
//
//// MARK: - Weather
//public struct Weather: Codable {
//    public var coded: [String]?
//    public var count: Double?
//    public var phrase, primary, primaryCoded, icon: String?
//}
//
///*
//   "weather": {
//                           "coded": [
//                               ":L:R",
//                               "::L"
//                           ],
//                           "count": 2,
//                           "phrase": "Sunny with Light Rain",
//                           "primary": "Light Rain",
//                           "primaryCoded": ":L:R",
//                           "icon": "rain.png"
//                       },
//
// */
