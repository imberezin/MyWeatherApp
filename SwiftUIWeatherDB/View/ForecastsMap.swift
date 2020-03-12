//
//  ForecastsMap.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/27/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import MapKit

struct ForecastsMap: View {
    
    @EnvironmentObject var  forecastsListVM: ForecastsDataVM
    @State var showInfo: Bool = false
    @State var selectedItem: Int = -1

    var body: some View {
        
        
        VStack {
            MapView(coordinate: CLLocationCoordinate2D(latitude: 31.771959, longitude: 35.217018),latitudeDelta: 1.0,longitudeDelta: 1.0,annotations: self.forecastsListVM.forecastsAnnotations, showInfo: self.$showInfo, selectedItem: $selectedItem)
                    .edgesIgnoringSafeArea(.top)
                    .onAppear(perform: loadAnnotations)
                    .sheet(isPresented: $showInfo) {
                        CityMepView(forecast: self.forecastsListVM.forecastsArrayVM[self.selectedItem], city: self.forecastsListVM.cityData[self.selectedItem], showInfo: self.$showInfo, selectedItem: self.selectedItem)//.environmentObject(self.forecastsListVM)
                        }
        }
    }
    
    func loadAnnotations()  {
        self.forecastsListVM.buildAnnotations()
    }
}

struct ForecastsMap_Previews: PreviewProvider {
    static var previews: some View {
        ForecastsMap()
    }
}
