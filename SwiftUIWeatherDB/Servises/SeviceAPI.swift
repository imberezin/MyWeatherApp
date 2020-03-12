//
//  SeviceAPI.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/24/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import Combine

class SeviceAPI: NSObject{
    
    
    func loadWeatherToCity(_ location: City, daysLimit: Int = 1)  -> AnyPublisher<Forecasts, Error> {
        
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy" // from=02/26/2020
        let now = df.string(from: Date())

        print("now = \(now)")
        
        
        let str = "https://api.aerisapi.com/forecasts?p=\(location.locationCoordinate.latitude),\(location.locationCoordinate.longitude)&filter=day&radius=50mi&format=json&from=\(now)&to=+5days&radius=50mi&filter=allstations&limit=7&client_id=U6MimTcevpZ4eVf8Ft90Q&client_secret=5ZGSWYDBJer8BS1aoxXHhsJV6bBRCnm0rOMcLwwM"
//        let str = "https://api.aerisapi.com/observations/summary/closest?p=\(location.locationCoordinate.latitude),\(location.locationCoordinate.longitude)&radius=50mi&format=json&from=\(now)&to=03/14/2020=&radius=50mi&filter=allstations&limit=\(daysLimit)&client_id=U6MimTcevpZ4eVf8Ft90Q&client_secret=5ZGSWYDBJer8BS1aoxXHhsJV6bBRCnm0rOMcLwwM"
      
        let strUrl = str.encodeUrl()!
        
        print(strUrl)
        guard let url = URL(string: strUrl) else {
            fatalError("Invalid URL")
        }
        // print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: Forecasts.self, decoder: self.newJSONDecoder())
            .eraseToAnyPublisher()
    }

    
    func loadWeatherToLocation(_ location: String, daysLimit: Int = 1)  -> AnyPublisher<Forecasts, Error> {
        
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy" // from=02/26/2020
        let now = df.string(from: Date())

        print("now = \(now)")
        
        let str = "https://api.aerisapi.com/observations/summary/closest?p=\(location)&format=json&from=\(now)&radius=50mi&filter=allstations&limit=\(daysLimit)&client_id=U6MimTcevpZ4eVf8Ft90Q&client_secret=5ZGSWYDBJer8BS1aoxXHhsJV6bBRCnm0rOMcLwwM"
      
        let strUrl = str.encodeUrl()!
        
        guard let url = URL(string: strUrl) else {
            fatalError("Invalid URL")
        }
        // print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: Forecasts.self, decoder: self.newJSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    var cancellable: AnyCancellable?

    func loadmultiWeatherToLocation(_ location : [String], daysLimit: Int = 1) ->  [AnyPublisher<Forecasts, Error>]{
        
        let str = "https://api.aerisapi.com/observations/summary/closest?p=\(location.first!)&format=json&from=02/24/2020&radius=50mi&filter=allstations&limit=\(daysLimit)&client_id=U6MimTcevpZ4eVf8Ft90Q&client_secret=5ZGSWYDBJer8BS1aoxXHhsJV6bBRCnm0rOMcLwwM"

          let strUrl = str.encodeUrl()!

          guard let url = URL(string: strUrl) else {
              fatalError("Invalid URL")
          }


        let str1 = "https://api.aerisapi.com/observations/summary/closest?p=\(location.last!)&format=json&from=02/24/2020&radius=50mi&filter=allstations&limit=\(daysLimit)&client_id=U6MimTcevpZ4eVf8Ft90Q&client_secret=5ZGSWYDBJer8BS1aoxXHhsJV6bBRCnm0rOMcLwwM"

          let strUrl1 = str1.encodeUrl()!

          guard let url1 = URL(string: strUrl1) else {
              fatalError("Invalid URL")
          }

        let publisher1 = URLSession.shared.dataTaskPublisher(for: url)
        .receive(on: RunLoop.main)
        .map {
            $0.data
        }
        .decode(type: Forecasts.self, decoder: self.newJSONDecoder()).eraseToAnyPublisher()

        let publisher2 = URLSession.shared.dataTaskPublisher(for: url1)
        .receive(on: RunLoop.main)
        .map {
            $0.data
        }
        .decode(type: Forecasts.self, decoder: self.newJSONDecoder()).eraseToAnyPublisher()

        return [publisher1, publisher2]
    }
    
    func loadmultiWeatherToLocation2(_ location : [String], daysLimit: Int = 1){
            
            let str = "https://api.aerisapi.com/observations/summary/closest?p=\(location.first!)&format=json&from=02/24/2020&radius=50mi&filter=allstations&limit=\(self)&client_id=U6MimTcevpZ4eVf8Ft90Q&client_secret=5ZGSWYDBJer8BS1aoxXHhsJV6bBRCnm0rOMcLwwM"

              let strUrl = str.encodeUrl()!

              guard let url = URL(string: strUrl) else {
                  fatalError("Invalid URL")
              }


            let str1 = "https://api.aerisapi.com/observations/summary/closest?p=\(location.last!)&format=json&from=02/24/2020&radius=50mi&filter=allstations&limit=\(daysLimit)&client_id=U6MimTcevpZ4eVf8Ft90Q&client_secret=5ZGSWYDBJer8BS1aoxXHhsJV6bBRCnm0rOMcLwwM"

              let strUrl1 = str1.encodeUrl()!

              guard let url1 = URL(string: strUrl1) else {
                  fatalError("Invalid URL")
              }

            let publisher1 = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: Forecasts.self, decoder: self.newJSONDecoder())

            let publisher2 = URLSession.shared.dataTaskPublisher(for: url1)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: Forecasts.self, decoder: self.newJSONDecoder())

            self.cancellable = Publishers.Zip(publisher1, publisher2)
            .eraseToAnyPublisher()
                .catch { _ in Just((Forecasts.placeholder, Forecasts.placeholder)) }
                .sink(receiveCompletion: { _ in
                    print("$receiveCompletion")
                }, receiveValue: { telAviv, jerusalem in
                    print("--==============--")
                    print(telAviv)
                    print("--==============--")
                    print(jerusalem)
                    print("--==============--")
            })
        }

    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
       
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


/*
 
 Test apis
 //        let publishers  = self.seviceAPI.loadmultiWeatherToLocation2(["tel aviv,israel","Jerusalem,israel"])
         
 //        self.cancellable = publisher2
 //            .catch { _ in Just(Forecasts.placeholder) }
 //                        .sink(receiveCompletion: { _ in }, receiveValue: { telAviv in
 //                            print("--==============--")
 //                            print(telAviv)
 //                            print("--==============--")
 //                    })
 //
 //        self.cancellable2 = publisher1
 //            .catch { _ in Just(Forecasts.placeholder) }
 //                        .sink(receiveCompletion: { _ in }, receiveValue: { telAviv in
 //                            print("--==============--")
 //                            print(telAviv)
 //                            print("--==============--")
 //                    })

 //        self.cancellable = Publishers.Zip(publishers.first!, publishers.last!)
 //                        .catch { _ in Just((Forecasts.placeholder(), Forecasts.placeholder())) }
 //                .sink(receiveCompletion: { _ in }, receiveValue: { telAviv, jerusalem in
 //                    print("--==============--")
 //                    print(telAviv)
 //                    print("--==============--")
 //                    print(jerusalem)
 //                    print("--==============--")
 //            })

 
 
 //        self.cancellable = Publishers.Zip4(publishers[0], publishers[1],publishers[2], publishers[3]).eraseToAnyPublisher()
 //            .catch { _ in Just((Forecasts.placeholder, Forecasts.placeholder, Forecasts.placeholder, Forecasts.placeholder)) }
 //            .sink(receiveCompletion: { _ in }, receiveValue: { a1, a2, a3, a4 in
 //                print("--=======\(self.cityNames[0])=======--")
 //                print(a1)
 //                print("--=======\(self.cityNames[1])=======--")
 //                print(a2)
 //                print("--=======\(self.cityNames[2])=======--")
 //                print(a3)
 //                print("--=======\(self.cityNames[3])=======--")
 //                print(a4)
 //                print("--======End========--")
 //
 //            })

 

    


 
 
 
 //        let publisher1 = self.seviceAPI.loadWeatherToLocation("tel aviv,israel")
 //
 //        let publisher2 = self.seviceAPI.loadWeatherToLocation("Jerusalem,israel")
 //
 //        self.cancellable = Publishers.Zip(publisher1, publisher2).eraseToAnyPublisher()
 //
 //            .catch { _ in Just((Forecasts.placeholder, Forecasts.placeholder)) }
 //            .sink(receiveCompletion: { _ in }, receiveValue: { telAviv, jerusalem in
 //                print("--======telAviv========--")
 //                print(telAviv)
 //                print("--========jerusalem=====--")
 //                print(jerusalem)
 //                print("--======end========--")
 //        })

 
 
 ,
 {
     "city": "Tel Aviv",
     "state": "Israel",
     "id": 1002,
     "coordinates": {
         "latitude": 32.08088,
         "longitude": 34.78057
     },
     "imageName": "telAviv"
 },
 {
     "city": "haifa",
     "state": "Israel",
     "id": 1003,
     "coordinates": {
         "latitude": 32.81841,
         "longitude": 34.9885
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Beersheba",
     "state": "Israel",
     "id": 1004,
     "coordinates": {
         "latitude": 31.25181,
         "longitude": 34.7913
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Ben-Gurion",
     "state": "Israel",
     "id": 1005,
     "coordinates": {
         "latitude": 31.9467,
         "longitude": 34.8903
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Modiin",
     "state": "Israel",
     "id": 1006,
     "coordinates": {
         "latitude": 31.89825,
         "longitude": 35.01051
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Eilat",
     "state": "Israel",
     "id": 1008,
     "coordinates": {
         "latitude": 29.56111,
         "longitude": 34.95167
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Tiberias",
     "state": "Israel",
     "id": 1009,
     "coordinates": {
         "latitude": 32.79556,
         "longitude": 35.52861
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Safed",
     "state": "Israel",
     "id": 1010,
     "coordinates": {
         "latitude": 32.96465,
         "longitude": 35.496
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Nahariya",
     "state": "Israel",
     "id": 1011,
     "coordinates": {
         "latitude": 33.01135,
         "longitude": 35.09467
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Ashdod",
     "state": "Israel",
     "id": 1012,
     "coordinates": {
         "latitude": 31.79213,
         "longitude": 34.64966
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Ashqelon",
     "state": "Israel",
     "id": 1013,
     "coordinates": {
         "latitude": 31.66926,
         "longitude": 34.57149
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Bet Shemesh",
     "state": "Israel",
     "id": 1014,
     "coordinates": {
         "latitude": 31.73072,
         "longitude": 34.99293
     },
     "imageName": "jerusalem"
 },
 {
     "city": "Netanya",
     "state": "Israel",
     "id": 1015,
     "coordinates": {
         "latitude": 32.321457,
         "longitude": 34.853195
     },
     "imageName": "jerusalem"
 }
*/

