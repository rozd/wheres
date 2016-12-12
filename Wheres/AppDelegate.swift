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
import Fabric
import Crashlytics
import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    //-------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //-------------------------------------------------------------------------

    var window: UIWindow?
    var mainViewController: MainViewController?
    
    var wheres:Wheres!
    var viewModel:MainViewModel!

    private var isLoggedIn:Bool?
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - UIApplicationDelegate
    //
    //-------------------------------------------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase configuration
        
        FIRApp.configure()
        
        // Google Sign In configuration
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        // Facebook Login configuration
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Subscribe to notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUserDidLogin(notification:)), name: .AccountUserDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUserDidLogout(notification:)), name: .AccountUserDidLogout, object: nil)
        
        // Create Model
        
        self.wheres = Wheres()
        
        // Creates main ViewModel and injects Model into it
        
        self.viewModel = MainViewModel(wheres: self.wheres)
        
        if let mainViewController = self.window?.rootViewController as? MainViewController
        {
            self.mainViewController = mainViewController
            self.mainViewController?.viewModel = viewModel;
        }
        
        // Fabric initialization
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApp = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        
        var handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApp, annotation: [:])
        handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        
        return handled
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

    private func showAuthScreen()
    {
        guard isLoggedIn == nil || isLoggedIn! == true else {
            return
        }
        
        isLoggedIn = false
        
        if let mainViewController = self.mainViewController
        {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            
            let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController;
            
            mainViewController.setViewControllers([signInViewController], animated: true)
        }
    }
    
    private func showMainScreen()
    {
        guard isLoggedIn == nil || isLoggedIn! == false else {
            return
        }
        
        isLoggedIn = true
        
        if let mainViewController = self.mainViewController
        {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            
            let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController;
            
            mainViewController.setViewControllers([mapViewController], animated: true)
        }
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Notification handlers
    //
    //-------------------------------------------------------------------------

    func handleAccountUserDidLogin(notification:Notification)
    {
        showMainScreen()
    }
    
    func handleAccountUserDidLogout(notification:Notification)
    {
        showAuthScreen()
    }
}

