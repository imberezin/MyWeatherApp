//
//  CircleImage.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/3/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    var imageName: String
    
    var body: some View {
        
        Image(imageName)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
    }
    
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(imageName: "jerusalem")
    }
}
