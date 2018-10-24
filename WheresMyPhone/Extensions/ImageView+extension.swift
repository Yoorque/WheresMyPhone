//
//  ImageView+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit

extension UIImage {
    
    ///Extends instance of `UIImage` to scale to a specified `size`.
    ///- Parameter size: Desired size to scale to.
    ///- Returns: Scaled `UIImage`.
    func scaleImageTo(_ size: CGSize) -> UIImage {
        
        let imageSize = self.size
        let widthRatio = size.width / imageSize.width
        let heightRatio = size.height / imageSize.height
        
        let newSize = CGSize(width: imageSize.width * widthRatio, height: imageSize.height * heightRatio)
        
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    ///Extends instance of `UIImage` to scale by desired amount.
    ///- Parameter scale: Desired amount to scale by.
    ///- Returns: Scaled `UIImage`.
    func scaleImageBy(_ scale: Int) -> UIImage {
        let imageSize = self.size
        
        let newWidth = imageSize.width / CGFloat(scale)
        let newHeight = imageSize.height / CGFloat(scale)
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, CGFloat(scale))
        self.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
