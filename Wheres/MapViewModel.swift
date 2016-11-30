//
//  MapViewModel.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation

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
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Properties
    //
    //-------------------------------------------------------------------------
    
    let wheres:Wheres;

}
