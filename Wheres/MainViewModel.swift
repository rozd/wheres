//
//  MainViewModel.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation

class MainViewModel
{
    //-------------------------------------------------------------------------
    //
    //  MARK: Lifecycle
    //
    //-------------------------------------------------------------------------
    
    init(wheres:Wheres)
    {
        self.wheres = wheres;
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Properties
    //
    //-------------------------------------------------------------------------
    
    let wheres:Wheres;
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Methods
    //
    //-------------------------------------------------------------------------
    
    func newAuthViewModel() -> AuthViewModel
    {
        return AuthViewModel(account: self.wheres.account)
    }
    
    func newMapViewModel() -> MapViewModel
    {
        return MapViewModel(wheres: self.wheres, account: self.wheres.account)
    }
}
