//
//  CityMepViewVM.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/8/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

class CityMepViewVM: ObservableObject {
    
    @Published var days: [String] = [String]()

    init() {
           self.buildWeek()
    }
       
    func buildWeek(){
           let now = Date()
           let calendar = Calendar.current
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EE"
           var tempArr = [String]()
           for index in 1...5 {
               let date = calendar.date(byAdding: .day, value: index, to: now)!
               let dayInWeek = dateFormatter.string(from: date)
               tempArr.append(dayInWeek)
           }
           self.days = tempArr

           
    }
}

