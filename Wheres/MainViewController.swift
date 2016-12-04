//
//  ViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit


class MainViewController: UINavigationController, UINavigationControllerDelegate
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
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
    {
        super.setViewControllers(viewControllers, animated: animated)
        
        for viewController in self.viewControllers
        {
            self.setViewModelFor(viewController: viewController)
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Overridden methods
    //
    //--------------------------------------------------------------------------
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        super.pushViewController(viewController, animated: animated);
        
        self.setViewModelFor(viewController: viewController)
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Injects view model for specified view controller
     */
    private func setViewModelFor(viewController controller: UIViewController)
    {
        if let signInViewController = controller as? SignInViewController
        {
            signInViewController.viewModel = self.viewModel.newAuthViewModel()
        }
        else if let signUpViewController = controller as? SignUpViewController
        {
            signUpViewController.viewModel = self.viewModel.newAuthViewModel()
        }
        else if let mapViewController = controller as? MapViewController
        {
            mapViewController.viewModel = self.viewModel.newMapViewModel()
        }
        else if let profileController = controller as? ProfileViewController
        {
            profileController.viewModel = self.viewModel.newAuthViewModel();
        }
    }

//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
//    {
//        self.setViewModelFor(viewController: viewController)
//    }
}

