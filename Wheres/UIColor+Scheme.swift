//
//  UIColor+Scheme.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/3/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(fromHex value:Int)
    {
        self.init(red:(value >> 16) & 0xff, green:(value >> 8) & 0xff, blue:value & 0xff)
    }
    
    open class var redCadmium: UIColor
    {
        return UIColor(fromHex: 0xF3495D)
    }
    
    open class var blueSlate: UIColor
    {
        return UIColor(fromHex: 0x302759)
    }
    
    open class var yellowDeco: UIColor
    {
        return UIColor(fromHex: 0xF0F66E)
    }
    
    open class var greenOlivine: UIColor
    {
        return UIColor(fromHex: 0xA8C686)
    }
    
    open class var greenLoafer: UIColor
    {
        return UIColor(fromHex: 0xF1F8EB)
    }
    
    open class var blueIndigo: UIColor
    {
        return UIColor(fromHex: 0x4F69C6)
    }
    
    open class var blueCornflower: UIColor
    {
        return UIColor(fromHex: 0x6282F5)
    }
    
    open class var blueMalibu: UIColor
    {
        return UIColor(fromHex: 0x829DFF)
    }
}
