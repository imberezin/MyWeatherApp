//
//  WidgetView.swift
//  swiftUITodayExtensions
//
//  Created by Israel Berezin on 3/12/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import CoreData
import CoreLocation

struct WidgetView: View {
    
    @ObservedObject var locationDataManager: LocationDataManager
    
    init() {
        
        self.locationDataManager = LocationDataManager()
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                Text("\((self.locationDataManager.city.city.uppercased()))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                Text("Israel".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            if self.locationDataManager.forecastsArrayVM != nil && self.locationDataManager.forecastsArrayVM?.forecastsVM != nil{
                FirstMidView(forecastVM: (self.locationDataManager.forecastsArrayVM?.getFirstItem())!)
            }
            Spacer()
        }.padding()
            .onAppear(perform: load)
    }
    
    func load(){
        self.locationDataManager.loadData()
    }
}

struct FirstMidView: View {
    
    var forecastVM: ForecastsVM
    
    var body: some View {
        HStack(alignment: .top){
            VStack(alignment: .leading , spacing: 4){
                
                Text("\(forecastVM.tempAvgC)°C".uppercased())
                    .modifier(PrimaryLabel())
                HStack{
                    Text("Feels Like".uppercased())
                        .modifier(PrimaryLabel())
                    Text("\(forecastVM.loolLikeC)°C")
                        .modifier(PrimaryLabel())
                }
                Text("\(forecastVM.sky)".uppercased())
                    .modifier(PrimaryLabel())
            }
            Spacer()
            Image (forecastVM.weatherIcon.lowercased()).resizable().frame(width: 60, height: 60, alignment: .center)
        }
    }
}


struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}


struct PrimaryLabel: ViewModifier {
    
    let font = Font.system(.subheadline).weight(.semibold)
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(Color.black)
    }
}
