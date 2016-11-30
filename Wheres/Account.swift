//
//  Account.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

extension Notification.Name
{
    public static let AccountUserDidLogin = Notification.Name("AccountUserDidLogin")
    public static let AccountUserDidLogout = Notification.Name("AccountUserDidLogout")
}

class Account : NSObject
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Lifecycle
    //
    //--------------------------------------------------------------------------
    
    override init()
    {
        super.init()
        
        _stateChangeHandler = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            
            self.currentUser = user
        })
    }
    
    deinit
    {
        if _stateChangeHandler != nil
        {
            FIRAuth.auth()?.removeStateDidChangeListener(_stateChangeHandler!);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Variables
    //
    //--------------------------------------------------------------------------
    
    private var _stateChangeHandler:FIRAuthStateDidChangeListenerHandle?

    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------

    var currentUser: FIRUser?
    {
        didSet
        {
            if currentUser != nil
            {
                NotificationCenter.default.post(name: .AccountUserDidLogin, object: nil)
            }
            else
            {
                NotificationCenter.default.post(name: .AccountUserDidLogout, object: nil)
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Public API
    //-------------------------------------
    
    func signIn(withEmail email:String, password:String)
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if user != nil
            {
                self.currentUser = user
            }
            else if let errorMessage = error?.localizedDescription
            {
                self.showMessage(message: errorMessage, withTitle: "Error")
            }
            else
            {
                self.showMessage(message: "Could not to login you due to unknown error", withTitle: "Error")
            }
        })
    }
    
    func signUp(_ email:String, password:String)
    {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if user != nil
            {
                self.currentUser = user
            }
            else if let errorMessage = error?.localizedDescription
            {
                self.showMessage(message: errorMessage, withTitle: "Error")
            }
            else
            {
                self.showMessage(message: "Could not create an account due to unknown error.", withTitle: "Error")
            }
        })
    }
    
    func signOut()
    {
        do
        {
            try FIRAuth.auth()?.signOut()
        }
        catch let error as NSError
        {
            showMessage(message: error.localizedDescription, withTitle: "Error")
        }
    }

    //-------------------------------------
    //  Methods: Internal
    //-------------------------------------
    
    private func showMessage(message: String, withTitle title: String)
    {
        if let currentViewController = findTopmostViewController()
        {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            currentViewController.present(controller, animated: true, completion: nil)
        }
    }
    
    private func findTopmostViewController() -> UIViewController?
    {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            var controller = appDelegate.window?.rootViewController
            
            while controller?.presentedViewController != nil
            {
                controller = controller?.presentedViewController
            }
            
            return controller
        }
        
        return nil
    }
}
