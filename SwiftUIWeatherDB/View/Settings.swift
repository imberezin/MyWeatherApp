//
//  Settings.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 2/27/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        NavigationView{
            Text("Hello, World!")
            
            .navigationBarTitle(Text("Settings"))
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
