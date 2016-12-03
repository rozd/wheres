//
//  MapViewModel.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase
import GeoFire

protocol MapViewModelDelegate : class
{
    func mapViewModelDidUserAdded(user: User)
    func mapViewModelDidUserRemoved(user: User, atIndex index: Int)
    func mapViewModelDidUserChanged(user: User, atIndex index: Int)
    func mapViewModelDidUsersChange(users:[User])
    
    func mapViewModelDidUserAnnotationAdded(annotation: UserAnnotation)
    func mapViewModelDidUserAnnotationRemoved(annotation: UserAnnotation)
}

class MapViewModel
{
    //-------------------------------------------------------------------------
    //
    //  MARK: Lifecycle
    //
    //-------------------------------------------------------------------------
    
    init(wheres:Wheres, account: Account)
    {
        self.wheres = wheres
        self.account = account
    }
    
    deinit
    {
        stopMonitorUsers()
        stopMonitorLocations()
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Properties
    //
    //-------------------------------------------------------------------------
    
    //------------------------------------
    //
    //------------------------------------
    
    let wheres: Wheres
    let account: Account

    var users: [User] = []
    
    private var usersMap: [String : User] = [:]
    
    private var annotationsMap: [String : UserAnnotation] = [:]
    
    //------------------------------------
    //  delegate
    //------------------------------------
    
    weak var delegate: MapViewModelDelegate?
    
    private var usersQuery: FIRDatabaseReference?
    
    private var regionQuery: GFRegionQuery?
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Methods
    //
    //-------------------------------------------------------------------------
    
    //-------------------------------------
    //  Methods: Monitor user changes
    //-------------------------------------
    
    func monitorUsers()
    {
        self.usersQuery = self.wheres.database.child("users")
        
        var usersChangeHandle: UInt?
        
        usersChangeHandle = self.usersQuery?.observe(.value, with: { (snapshot:FIRDataSnapshot) -> Void in
            
            if let handle = usersChangeHandle
            {
                // remove observer for change users, we don't need it anymore
                
                self.usersQuery?.removeObserver(withHandle: handle)
            }
            
            self.users = []
            self.usersMap = [:]
            
            for child in snapshot.children
            {
                let user = User(snapshot: child as! FIRDataSnapshot)
                
                if user.uid == self.account.currentUser?.uid
                {
                    // ignore self
                    continue
                }
                
                self.users.append(user)
                self.usersMap[user.uid] = user
            }

            self.delegate?.mapViewModelDidUsersChange(users: self.users)
        })
        
        self.usersQuery?.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
            
            let user = User(snapshot: snapshot)
            
            self.users.append(user)
            self.usersMap[user.uid] = user
            
            self.delegate?.mapViewModelDidUserAdded(user: user)
        })
        
        self.usersQuery?.observe(.childRemoved, with: { (snapshot: FIRDataSnapshot) in
            
            for (index, user) in self.users.enumerated()
            {
                if user.uid == snapshot.key
                {
                    self.users.remove(at: index)
                    self.usersMap.removeValue(forKey: user.uid)
                    
                    self.delegate?.mapViewModelDidUserRemoved(user: user, atIndex: index)
                    
                    break
                }
            }
        })
    }
    
    func stopMonitorUsers()
    {
        self.usersQuery?.removeAllObservers()
        self.usersQuery = nil
    }
    
    //-------------------------------------
    //  Methods: Monitor location changes
    //-------------------------------------
    
    func monitorLocations(within region: MKCoordinateRegion)
    {
        if let query = self.regionQuery
        {
            query.region = region
        }
        else
        {
            self.regionQuery = self.wheres.geoFire.query(with: region)
            
            self.regionQuery?.observe(.keyMoved, with: { (key: String?, location: CLLocation?) in
                
                if let key = key, let annotation = self.annotationsMap[key], let location = location
                {
                    if let user = self.usersMap[key]
                    {
                        user.location = location
                        
                        self.delegate?.mapViewModelDidUserChanged(user: user, atIndex: self.users.index(of: user)!)
                    }

                    UIView.animate(withDuration: 2.0, animations: {
                        
                        annotation.coordinate = location.coordinate
                    })
                }
            })
            
            self.regionQuery?.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
                
                if let key = key, let location = location
                {
                    if let user = self.usersMap[key]
                    {
                        user.location = location
                        
                        let annotation = UserAnnotation(user: user)
                        
                        self.annotationsMap[key] = annotation
                        
                        self.delegate?.mapViewModelDidUserAnnotationAdded(annotation: annotation)
                    }
                }
            })
            
            self.regionQuery?.observe(.keyExited, with: { (key: String?, location:CLLocation?) in
                
                if let key = key, let location = location
                {
                    if let user = self.usersMap[key]
                    {
                        user.location = location
                    }
                    
                    if let annotation = self.annotationsMap[key]
                    {
                        self.annotationsMap.removeValue(forKey: key)
                        
                        self.delegate?.mapViewModelDidUserAnnotationRemoved(annotation: annotation)
                    }
                }
            })
        }
    }
    
    func stopMonitorLocations()
    {
        self.regionQuery?.removeAllObservers()
        self.regionQuery = nil
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Methods
    //
    //-------------------------------------------------------------------------
    
}
