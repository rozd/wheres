//
//  UserAnnotation.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/2/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import MapKit

/**
 * Entity object, describes position of Friedn. TODO: Rename to FriendAnnotation
 */
class UserAnnotation: NSObject, MKAnnotation
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Lifecycle
    //
    //--------------------------------------------------------------------------
    
    init(user: User)
    {
        self.user = user
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    let user: User

    public var coordinate: CLLocationCoordinate2D
    {
        get {
            return user.location!.coordinate
        }
        set {
            user.location = CLLocation(latitude: newValue.latitude, longitude: newValue.longitude)
        }
    }
    
    public var title: String?
    {
        get {
            return user.displayName
        }
    }
    
    public var subtitle: String?
    {
        get {
            return nil
        }
    }
}
