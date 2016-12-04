//
//  UIViewControllerRoutines.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/4/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import UIKit

class UIAlertControllerRoutines
{
    public static func findTopmostViewController() -> UIViewController?
    {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            var controller = appDelegate.window?.rootViewController
            
            while controller?.presentedViewController != nil
            {
                controller = controller?.presentedViewController
            }
        
            return controller
        }
        
        return nil
    }
}
