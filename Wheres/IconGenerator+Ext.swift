//
//  IconGenerator+Ext.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/4/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import CoreGraphics
import IGIdenticon
import UIKit

extension IconGenerator
{
    func icon(from string: String, size: CGSize, scale: CGFloat = UIScreen.main.scale, backgroundColor: UIColor) -> UIImage?
    {
        guard let image = self.icon(from: string, size: size, scale: scale) else {
            return nil
        }
        
        if let cgImage = image.cgImage
        {
            let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
            
            let context = CGContext(
                data: nil,
                width: Int(cgImage.width),
                height: Int(cgImage.height),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: cgImage.bytesPerRow,
                space: cgImage.colorSpace!,
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGImageByteOrderInfo.order32Little.rawValue
            )!
            
            context.setFillColor(backgroundColor.cgColor)
            context.fill(rect)
            
            context.draw(cgImage, in: rect)
            
            return UIImage(cgImage: context.makeImage()!)
        }
        
        return nil
    }
}
