//
//  ImageView+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    
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
}
