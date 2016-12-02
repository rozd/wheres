//
//  MapViewModel.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol MapViewModelDelegate : class
{
    func mapViewModelDidUserAdded(user: User)
    func mapViewModelDidUserRemoved(user: User, fromIndex index: Int)
    func mapViewModelDidUsersChange(users:[User])
}

class MapViewModel
{
    //-------------------------------------------------------------------------
    //
    //  MARK: Lifecycle
    //
    //-------------------------------------------------------------------------
    
    init(wheres:Wheres)
    {
        self.wheres = wheres;
        
        self.wheres.requestUsers(with: handleUsersChange)
        
        self.wheres.startMonitorUserAdded(with: handleUserAdded)
        self.wheres.startMonitorUserRemoved(with: handleUserRemoved)
    }
    
    deinit
    {
        self.wheres.stopMonitorUserAdded()
        self.wheres.stopMonitorUserRemoved()
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Properties
    //
    //-------------------------------------------------------------------------
    
    //------------------------------------
    //
    //------------------------------------
    
    let wheres:Wheres;

    var users: [User] = []
    
    //------------------------------------
    //  delegate
    //------------------------------------
    
    weak var delegate: MapViewModelDelegate?
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Methods
    //
    //-------------------------------------------------------------------------
    
    private func handleUsersChange(users:[User])
    {
        self.users = users
        
        delegate?.mapViewModelDidUsersChange(users: self.users)
    }
    
    private func handleUserAdded(user:User)
    {
        self.users.append(user)
        
        delegate?.mapViewModelDidUserAdded(user: user)
    }
    
    private func handleUserRemoved(uid: String)
    {
        for (index, user) in self.users.enumerated()
        {
            if user.uid == uid
            {
                self.users.remove(at: index)
                
                delegate?.mapViewModelDidUserRemoved(user: user, fromIndex: index)
                
                return
            }
        }
    }
}
