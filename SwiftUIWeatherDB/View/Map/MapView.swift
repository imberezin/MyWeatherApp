//
//  MapView.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/3/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    
    var coordinate: CLLocationCoordinate2D
    
    var latitudeDelta = 0.02
    var longitudeDelta = 0.02
    
    var annotations: [MKAnnotation] = [MKAnnotation]()
    
    @Binding var showInfo: Bool
    @Binding var selectedItem: Int

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(WeatherAnnotation.self))
        
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        if annotations.count > 0{
            view.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 31.771959, longitude: 35.217018), showInfo: .constant(false), selectedItem: .constant(0))
    }
}

