//
//  CustomAnnotation.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/3/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import MapKit
import UIKit

/// - Tag: AnnotationExample
class WeatherAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    // Required if you set the annotation view's `canShowCallout` property to `true`
    var title: String? = ""
    
    // This property defined by `MKAnnotation` is not required.
    var subtitle: String? = ""
    
    var imageName: String? = "sunny"
    
    var sky: String? = "Clear"
    
    var arrayIndex: Int? = 0

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
}

