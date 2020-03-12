//
//  ForecastsList.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/27/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct ForecastsList: View {
    
    @EnvironmentObject var  forecastsListVM: ForecastsDataVM
    @State var showInfo: Bool = false

    
    var body: some View {
        // see: https://github.com/onmyway133/blog/issues/515 (list with index)
        let withIndex = forecastsListVM.forecastsArrayVM.enumerated().map({ $0 })

        return NavigationView{
            List(withIndex, id: \.element.id) { index, forecast in
                NavigationLink(destination: CityMepView(forecast: forecast, city: self.forecastsListVM.cityData[index], showInfo: self.$showInfo))
                {
                    WeatherCell(forecast: forecast.getFirstItem(), cityName: self.forecastsListVM.cityNameByIndex(index))
                }
            }.onAppear(perform: load)
            
            .navigationBarTitle(Text("Weather By List"))
        }
    }
    
    func load() {
        self.forecastsListVM.loadForecastsData()
    }

}

struct ForecastsList_Previews: PreviewProvider {
    static var previews: some View {
        ForecastsList()
    }
}



struct WeatherCell: View {
    
    let forecast: ForecastsVM
    let cityName: String
    
    
    var body: some View {
        HStack (alignment: .center, spacing: 10) {
            
            Text("\(self.cityName.uppercased())")

                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            Text("\(forecast.tempStrMinC) - \(forecast.tempStrMaxC)")
                .font(.subheadline)
                .fontWeight(.semibold)
            Image("\(forecast.weatherIcon.lowercased())").renderingMode(.original).resizable().frame(width: 27, height: 27, alignment: .center)
            
        }.padding()
    }
}
