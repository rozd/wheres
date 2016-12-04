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
let WheresTermsOfUseLink = "https://whres-d5103.firebaseapp.com/terms"
let WheresPrivacyPolicyLink = "https://whres-d5103.firebaseapp.com/privacy"

let WheresAvatarMiddleSize = 256
let WheresAvatarSmallSize = 96
let WheresAvatarExtraSmallSize = 64

let WheresFriendAnnotationViewSize = 32

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
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUserDidLogout(notification:)), name: .AccountUserDidLogout, object: nil)
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
    
    lazy var database = FIRDatabase.database().reference()
    
    lazy var geoFire: GeoFire = GeoFire(firebaseRef: FIRDatabase.database().reference().child("locations"))
    
    private lazy var locationManager: CLLocationManager =
    {
        let _manager = CLLocationManager()
        _manager.delegate = self
        _manager.activityType = .other
        _manager.desiredAccuracy = kCLLocationAccuracyBest
        
        return _manager
    }()
    
    private var locationUpdateTimer: Timer?
    
    private var isLocationTracking: Bool = false
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    //------------------------------------
    //  Methods: Private
    //------------------------------------
    
    private func startTrackLocation()
    {
        guard !isLocationTracking else {
            return
        }
        
        switch CLLocationManager.authorizationStatus()
        {
            case .notDetermined :
                locationManager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse :
                self.doStartTrackLocation()
                
            default:
                print("Not allowed")
        }
    }
    
    func doStartTrackLocation()
    {
        isLocationTracking = true
        
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
        
        locationManager.startUpdatingLocation()
    }
    
    private func stopTrackLocation()
    {
        guard isLocationTracking else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
        
        isLocationTracking = false
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Delegates
    //
    //--------------------------------------------------------------------------
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status
        {
            case .notDetermined :
                manager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse :
                self.doStartTrackLocation()
                
            default:
                print("Not allowed")
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        
        guard let currentUser = account.currentUser, locations.count > 0 else {
            return
        }
        
        locationUpdateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(doStartTrackLocation), userInfo: nil, repeats: false)
        
        var mostRecentLocation = locations[0]
        
        for location in locations
        {
            if location.timestamp > mostRecentLocation.timestamp
            {
                mostRecentLocation = location
            }
        }
        
        geoFire.setLocation(mostRecentLocation, forKey: currentUser.uid)
        
        database.child("users/\(currentUser.uid)/location").setValue(["lat" : mostRecentLocation.coordinate.latitude, "lon" : mostRecentLocation.coordinate.longitude])
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
