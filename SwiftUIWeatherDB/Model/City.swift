//
//  city.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct City: Hashable, Codable {

    var id: Int
    var city: String
    var imageName: String
    var state: String
    var coordinates: Coordinates

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

