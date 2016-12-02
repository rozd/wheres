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
    
    private var isLocationTracking: Bool = false
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    //------------------------------------
    //  Methods: Users
    //------------------------------------
    
    func requestUsers(with block: @escaping ([User]) -> Void)
    {
        let users = database.child("users")
        
        var handle:UInt?
        
        handle = users.observe(.value, with: { (snapshot:FIRDataSnapshot) -> Void in
            
            var newItems: [User] = []
            
            for child in snapshot.children
            {
                newItems.append(User(snapshot: child as! FIRDataSnapshot))
            }

            block(newItems)
            
            users.removeObserver(withHandle: handle!)
        })
    }
    
    //------------------------------------
    //  Methods: Monitor changes
    //------------------------------------
    
    func monitorRange()
    {
        
    }
    
    private var _monitorUserAddedHandle: UInt?
    
    func startMonitorUserAdded(with block: @escaping (User) -> Void)
    {
        let users = database.child("users")
        
        _monitorUserAddedHandle = users.observe(.childAdded, with: { (snapshot:FIRDataSnapshot) -> Void in
            
            block(User(snapshot: snapshot))
        })
    }
    
    func stopMonitorUserAdded()
    {
        let users = database.child("users")

        if let handle = _monitorUserAddedHandle
        {
            users.removeObserver(withHandle: handle)
        }
    }
    
    private var _monitorUserRemovedHandle: UInt?
    
    func startMonitorUserRemoved(with block: @escaping (String) -> Void)
    {
        let users = database.child("users")
        
        _monitorUserAddedHandle = users.observe(.childRemoved, with: { (snapshot:FIRDataSnapshot) -> Void in
            
            block(snapshot.key)
        })
    }
    
    func stopMonitorUserRemoved()
    {
        let users = database.child("users")
        
        if let handle = _monitorUserAddedHandle
        {
            users.removeObserver(withHandle: handle)
        }
    }
    
    //------------------------------------
    //  Methods: Private
    //------------------------------------
    
    private func startTrackLocation()
    {
        if !isLocationTracking
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined :
                locationManager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse :
                locationManager.startUpdatingLocation()
                
            default:
                print("Not allowed")
            }
        }
    }
    
    private func stopTrackLocation()
    {
        if isLocationTracking
        {
            guard isLocationTracking else {
                return
            }
            
            locationManager.stopUpdatingLocation()            
        }
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
