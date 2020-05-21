//
//  CityMepView.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/3/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import MapKit

struct CityMepView: View {
    
    let forecast: ForecastsDaysListVM
    let city: City
    let cityMepViewVM = CityMepViewVM()
    
    @Binding var showInfo: Bool //= false
    @State var selectedItem: Int = -1
    @State var currentPosition: CGFloat = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        ZStack (alignment: .bottom){
            MapView(coordinate: self.city.locationCoordinate, showInfo: self.$showInfo, selectedItem: $selectedItem)
                .edgesIgnoringSafeArea(.top)
                .overlay(Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "xmark.circle.fill").foregroundColor(.black).font(.title).opacity(self.showInfo ? 1 : 0).padding()
                }, alignment: .topTrailing)
            
            
            // .frame(height: 300)
            VStack(spacing: 8.0) {
                CircleImage(imageName: city.imageName)
                    .offset(y: -70)
                    .padding(.bottom, -130)
                    .gesture(DragGesture()
                        .onChanged { value in
                            print("value.translation.height = \(value.translation.height)")
                            if abs(Int(self.currentPosition) - Int(value.translation.height)) > 20{
                                self.currentPosition = value.translation.height
                            }
                    }
                    .onEnded { value in
                        if value.translation.height > 0 {
                            self.currentPosition = 250
                        } else {
                            self.currentPosition = 0
                        }
                    }
                )
                
                VStack(alignment: .leading) {
                    
                    HStack(alignment: .top) {
                        Text("\(city.city.uppercased())")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Israel".uppercased())
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                    }

                    ExDivider()
                }
                    .padding([.top, .leading, .trailing], 8)
                
                FirstMidView(forecastVM: forecast.getFirstItem())
                
                ExDivider().padding([.leading, .trailing], 8)
                
                SecondMidView(forecastVM: forecast.getFirstItem())
                
                NextDaysView(forecast: forecast, cityMepViewVM: cityMepViewVM)
                
            }.frame(height: 300).background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.65))).animation(.spring()).offset(y: CGFloat(self.currentPosition))
        }
    }
    
}

//struct CityMepView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityMepView(forecast: <#ForecastsVM#>, cityName: <#String#>)
//    }
//}

struct ExDivider: View {
    let color: Color = .black
    let width: CGFloat = 2
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}


/*
 //                       .overlay(
 //                    RoundedRectangle(cornerRadius: 20)
 //                        .stroke(Color.black, lineWidth: 2)
 //                )
 //                .padding(.all, 8)
 
 */


struct FirstMidView: View {
    
    var forecastVM: ForecastsVM
    
    var body: some View {
        HStack(alignment: .top){
            VStack(alignment: .leading , spacing: 8){
                
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
            Image (forecastVM.weatherIcon.lowercased()).resizable().frame(width: 75, height: 75, alignment: .center)
        }.padding([.leading, .trailing], 8)
    }
}

struct SecondMidView: View {
    
    var forecastVM: ForecastsVM
    
    var body: some View {
        VStack (spacing: 8) {
            HStack{
                HStack{
                    Text("Winds".uppercased())
                        .modifier(PrimaryLabel())
                    Text("\(forecastVM.windAvgKPH) kmh")
                        .modifier(PrimaryLabel())
                }
                Spacer()
                
                HStack{
                    Text("Humidity".uppercased())
                        .modifier(PrimaryLabel())
                    Text("\(forecastVM.humidity)%")
                        .modifier(PrimaryLabel())
                }
                
            }.padding([.leading, .trailing], 8)
            
            HStack{
                HStack{
                    Text("Visibility".uppercased())
                        .modifier(PrimaryLabel())
                    Text("\(forecastVM.visibility) km")
                        .modifier(PrimaryLabel())
                }
                Spacer()
                
                HStack{
                    Text("Sky Cover".uppercased())
                        .modifier(PrimaryLabel())
                    Text("\(forecastVM.skyCover)%".uppercased())
                        .modifier(PrimaryLabel())
                }
                
            }.padding([.leading, .trailing], 8)
        }
    }
}

struct NextDaysView: View {
    
    let forecast: ForecastsDaysListVM
    let cityMepViewVM: CityMepViewVM
    
    var body: some View {
        
        HStack() {

            ForEach(0 ..< 5) { index in
                VStack {
                    if self.forecast.itemByIndexExist(index){
                        Image (self.forecast.getItemByIndex(index)!.weatherIcon.lowercased()).resizable().frame(width: 25, height: 25, alignment: .center)
                    } else {
                        Image (self.forecast.getFirstItem().weatherIcon.lowercased()).resizable().frame(width: 25, height: 25, alignment: .center)
                        
                    }
                    Text(self.forecast.itemByIndexExist(index) ? "\(self.forecast.getItemByIndex(index)!.tempAvgC)°C".uppercased() : "?°C".uppercased())
                        .font(.footnote)
                        .foregroundColor(.white)
                    Text("\(self.cityMepViewVM.days[index])")
                        .font(.footnote)
                        .foregroundColor(.white)
                    
                }
                if index < 4 {
                    Spacer()
                }
            }
            
        }.padding(.all, 12)
    }
}
