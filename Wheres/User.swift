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

/**
 * Entity objects, contains information about a firend. TODO: Rename to Friend
 */
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
    
    init(snapshot: DataSnapshot)
    {
        let value = snapshot.value as? [String : AnyObject]
        
        self.uid = snapshot.key;
        
        self.displayName = value?["displayName"] as? String
        
        if let middleAvatarPath = value?["middleAvatarPath"] as? String
        {
            self.middleAvatarURL = URL(string: middleAvatarPath)
        }
        
        if let smallAvatarPath = value?["smallAvatarPath"] as? String
        {
            self.smallAvatarURL = URL(string: smallAvatarPath)
        }
        
        if let extraSmallAvatarPath = value?["extraSmallAvatarPath"] as? String
        {
            self.extraSmallAvatarURL = URL(string: extraSmallAvatarPath)
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
    
    var middleAvatarURL: URL?
    var smallAvatarURL: URL?
    var extraSmallAvatarURL: URL?
    
    var location: CLLocation?
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    
}
