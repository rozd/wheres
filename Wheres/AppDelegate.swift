//
//  AppDelegate.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    //-------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //-------------------------------------------------------------------------

    var window: UIWindow?
    
    var wheres:Wheres!;
    var viewModel:MainViewModel!;

    //-------------------------------------------------------------------------
    //
    //  MARK: - UIApplicationDelegate
    //
    //-------------------------------------------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase configuration
        
        FIRApp.configure()
        
        // Create Model
        
        self.wheres = Wheres()
        
        // Creates main ViewModel and injects Model into it
        
        self.viewModel = MainViewModel(wheres: self.wheres)
        
        if let mainViewController = self.window?.rootViewController as? ViewController
        {
            mainViewController.viewModel = viewModel;
        }
        
        // Fast check if there is current user
        
        if FIRAuth.auth()?.currentUser == nil
        {
            showAuthScreen()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //-------------------------------------------------------------------------
    //
    //  MARK: - Navigation
    //
    //-------------------------------------------------------------------------

    func showAuthScreen()
    {
        guard !(self.window?.rootViewController is SignInViewController) else {
            return
        }
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController;
        signInViewController.viewModel = self.viewModel.newAuthViewModel()
        
        self.window?.rootViewController = signInViewController;

    }
    
    func showMainScreen()
    {
        guard !(self.window?.rootViewController is ViewController) else {
            return
        }
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        
        let mainViewController = storyboard.instantiateInitialViewController() as! ViewController
        mainViewController.viewModel = self.viewModel;
        
        self.window?.rootViewController = mainViewController;
    }

}

