//
//  ImageExtensions.swift
//  SwiftUIWeather
//
//  Created by Israel Berezin on 3/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    func scaledImageToSizeImage(newSize: CGSize, addStroke: Bool) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func imageWithColor(color: UIColor, addStroke: Bool) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        if addStroke {
            let strokeRect = rect.insetBy(dx: 7.0, dy: 5.0)
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(3)
            context.strokeEllipse(in: strokeRect)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    /*
     -(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
     UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
     // Here pass new size you need
     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return newImage;
     }
     
     */
    
}
/*
 Country    Israel
 Latitude    31.771959
 Longitude    35.217018
 
 */
