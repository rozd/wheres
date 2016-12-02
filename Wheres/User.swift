//
//  User.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/2/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase

class User
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Lifecycle
    //
    //--------------------------------------------------------------------------
    
    init(snapshot:FIRDataSnapshot)
    {
        let value = snapshot.value as? [String : AnyObject]
        
        self.uid = snapshot.key;
        
        self.displayName = value?["displayName"] as? String
        
        if let lat = value?["location"]?["lat"] as? NSNumber, let lon = value?["location"]?["lon"] as? NSNumber
        {
            self.location = CLLocation(latitude: lat.doubleValue, longitude: lon.doubleValue)
        }
        else
        {
            self.location = nil
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    let uid: String
    
    var displayName: String?
    
    var location: CLLocation?
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    
}
