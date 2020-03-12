//
//  StringExtension.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import  UIKit

extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}
