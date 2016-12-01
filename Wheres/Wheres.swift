//
//  Wheres.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import FirebaseAuth
import GeoFire
import FirebaseDatabase

let WheresFirebaseStorageURL = "gs://whres-d5103.appspot.com"

class Wheres : NSObject, CLLocationManagerDelegate
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Lifecycle
    //
    //--------------------------------------------------------------------------
    
    override init()
    {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUserDidLogin(notification:)), name: .AccountUserDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUserDidLogout(notification:)), name: .AccountUserDidLogin, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    let account = Account()
    
    lazy var geoFire: GeoFire = GeoFire(firebaseRef: FIRDatabase.database().reference())
    
    private lazy var manager: CLLocationManager =
    {
        let _manager = CLLocationManager()
        _manager.delegate = self
        _manager.activityType = .other
        _manager.desiredAccuracy = kCLLocationAccuracyBest
        
        return _manager
    }()
    
    private var isLocationTracking: Bool = false
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    private func startTrackLocation()
    {
        guard !isLocationTracking else {
            return
        }
        
        switch CLLocationManager.authorizationStatus()
        {
            case .notDetermined :
                manager.requestAlwaysAuthorization()
            
            case .authorizedAlways, .authorizedWhenInUse :
                manager.startUpdatingLocation()
            
            default:
                print("Not allowed")
        }
    }
    
    private func stopTrackLocation()
    {
        guard isLocationTracking else {
            return
        }
        
        manager.stopUpdatingLocation()
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Deelegates
    //
    //--------------------------------------------------------------------------
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status
        {
            case .notDetermined :
                manager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse :
                manager.startUpdatingLocation()
                
            default:
                print("Not allowed")
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let currentUser = account.currentUser, locations.count > 0 else {
            return
        }
        
        var mostRecentLocation = locations[0]
        
        for location in locations
        {
            if location.timestamp > mostRecentLocation.timestamp
            {
                mostRecentLocation = location
            }
        }
        
        geoFire.setLocation(mostRecentLocation, forKey: currentUser.uid)
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Notification handlers
    //
    //--------------------------------------------------------------------------
    
    func handleAccountUserDidLogin(notification: Notification)
    {
        startTrackLocation()
    }
    
    func handleAccountUserDidLogout(notification: Notification)
    {
        stopTrackLocation()
    }
}
