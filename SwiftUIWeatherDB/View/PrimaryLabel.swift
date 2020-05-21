//
//  PrimaryLabel.swift
//  SwiftUIWeatherDB
//
//  Created by Israel Berezin on 3/15/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct PrimaryLabel: ViewModifier {
    
    let font = Font.system(.subheadline).weight(.semibold)
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(Color.white)
    }
}

