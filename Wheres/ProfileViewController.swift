//
//  ProfileViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    var viewModel: AuthViewModel!

    //--------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //--------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  MARK: Actions
    //-------------------------------------

    @IBAction func signOutButtonTapped(_ sender: Any)
    {
        self.viewModel.signOut()
    }
}
