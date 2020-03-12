//
//  MapViewCoordinator.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import MapKit


extension MapView{
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let coordinates = view.annotation?.coordinate else { return }
            let span = mapView.region.span
            let region = MKCoordinateRegion(center: coordinates, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, viewFor
            annotation: MKAnnotation) -> MKAnnotationView?{
            //Custom View for Annotation
            if let annotation = annotation as? WeatherAnnotation {
                let annotationView: MKAnnotationView = setupWeatherAnnotationView(for: annotation, on: mapView)
                return annotationView
                
            }else{
                
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
                annotationView.canShowCallout = true
                //Your custom image icon
                annotationView.image = UIImage(named: "AAAlocationPin")?.scaledImageToSizeImage(newSize: CGSize(width: 36, height: 36), addStroke: false)
                return annotationView
            }
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            // This illustrates how to detect which annotation type was tapped on for its callout.
            if let annotation = view.annotation, annotation.isKind(of: WeatherAnnotation.self) {
                if let annotation = annotation as? WeatherAnnotation{
                    print("Tapped Golden Gate Bridge annotation accessory view")
                    self.control.selectedItem = annotation.arrayIndex!
                    self.control.showInfo.toggle()
                }
            }
        }
        
        
        private func setupWeatherAnnotationView(for annotation: WeatherAnnotation, on mapView: MKMapView) -> MKAnnotationView {
            let reuseIdentifier = NSStringFromClass(WeatherAnnotation.self)
            let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
            
            flagAnnotationView.canShowCallout = true
            
            // Provide the annotation view's image.
            var image = UIImage(named: "AAAlocationPin")?.scaledImageToSizeImage(newSize: CGSize(width: 36, height: 36), addStroke: true)
            image = image!.imageWithColor(color: self.getAnnotationColor(skyCode: annotation.sky!), addStroke: true)
            
            flagAnnotationView.image = image
            
            // Provide the left image icon for the annotation.
            let accessoryImage = UIImage(named: annotation.imageName!)
            flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: accessoryImage)
            
            let rightButton = UIButton(type: .detailDisclosure)
            flagAnnotationView.rightCalloutAccessoryView = rightButton
            
            // Offset the flag annotation so that the flag pole rests on the map coordinate.
            let offset = CGPoint(x: image!.size.width / 2, y: -(image!.size.height / 2) )
            flagAnnotationView.centerOffset = offset
            
            return flagAnnotationView
        }
        
        func getAnnotationColor(skyCode: String) -> UIColor{
            print("skyCode = \(skyCode)")
            switch skyCode {
            case "Clear":
                return UIColor.init(red: 104.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
            case "Mostly Sunny":
                return UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
            case "Partly Cloudy":
                return UIColor.init(red: 153.0/255.0, green: 255.0/255.0, blue: 153.0/255.0, alpha: 1)
            case "Mostly Cloudy":
                return UIColor.init(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 1)
            case "Cloudy":
                return UIColor.init(red: 0.0/255.0, green: 76.0/255.0, blue: 153.0/255.0, alpha: 1)
            default:
                return UIColor.green
            }
            
        }
        
    }
}
