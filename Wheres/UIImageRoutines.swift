//
//  UIImageRoutines.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/1/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import UIKit

class UIImageRoutines
{
    public class func image(_ image:UIImage, scaledTo size:CGSize) -> UIImage?
    {
        UIGraphicsBeginImageContext(size)
        
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
    
