//
//  ViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit

class ViewController: UINavigationController, UINavigationControllerDelegate
{
    //--------------------------------------------------------------------------
    //
    //  MARK: Properties
    //
    //--------------------------------------------------------------------------
    
    var viewModel:MainViewModel!;
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Overridden methods
    //
    //--------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self;
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Methods
    //
    //--------------------------------------------------------------------------

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        if let signInViewController = viewController as? SignInViewController
        {
            signInViewController.viewModel = self.viewModel.newAuthViewModel()
        }
        else if let signUpViewController = viewController as? SignUpViewController
        {
            signUpViewController.viewModel = self.viewModel.newAuthViewModel()
        }
        else if let mapViewController = viewController as? MapViewController
        {
            mapViewController.viewModel = self.viewModel.newMapViewModel()
        }
        else if let profileController = viewController as? ProfileViewController
        {
            profileController.viewModel = self.viewModel.newAuthViewModel();
        }
    }
}

