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

class User : Equatable
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Class methods
    //
    //--------------------------------------------------------------------------
    
    public static func ==(lhs: User, rhs: User) -> Bool
    {
        return lhs.uid == rhs.uid
    }
    
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
        
        if let avatarMiddlePath = value?["avatarMiddlePath"] as? String
        {
            self.avatarMiddleURL = URL(string: avatarMiddlePath)
        }
        else
        {
            self.avatarMiddleURL = nil
        }
        
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
    
    let displayName: String?
    
    let avatarMiddleURL: URL?
    
    var location: CLLocation?
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    
}
