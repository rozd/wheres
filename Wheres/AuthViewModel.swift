//
//  AuthViewModel.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class AuthViewModel
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Lifecycle
    //
    //--------------------------------------------------------------------------
    
    init(account:Account)
    {
        print("AuthViewModel.init")
        
        self.account = account
    }
    
    deinit
    {
        print("AuthViewModel.deinit")
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    var account: Account

    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    func signIn(withEmail email: String, password: String)
    {
        account.signIn(withEmail: email, password: password)
    }
    
    func signUp(withEmail email: String, password: String)
    {
        account.signUp(email, password: password)
    }
    
    func signOut()
    {
        account.signOut()
    }
}
