//
//  ContentView.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/24/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import Combine

enum Tab: Int {
    case List, Map, Settings
}

struct ContentView: View {
    
    @State var selectedTab = Tab.List
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ForecastsList().tabItem{
                self.tabbarItem(text: "List", image: "list.bullet")
            }.tag(Tab.List)
            ForecastsMap().tabItem{
                self.tabbarItem(text: "Map", image: "globe")
            }.tag(Tab.Map)
            Settings().tabItem{
                self.tabbarItem(text: "Settings", image: "helm")
            }.tag(Tab.Settings)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
