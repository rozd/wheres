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

class AuthViewModel : NSObject
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
    
    func signUp(withEmail email: String, password: String, displayName: String?)
    {
        account.signUp(email, password: password, displayName: displayName)
    }
    
    func signOut()
    {
        account.signOut()
    }
    
    func changeAvatar(newAvatar image: UIImage)
    {
        account.changeAvatar(newAvatar: image)
    }
    
    func forgotPassword()
    {
        guard let currentViewController = UIAlertControllerRoutines.findTopmostViewController() else {
            return
        }
        
        let alertController = UIAlertController(title: "Reset password", message: "Please enter your email below:", preferredStyle: .alert)
        
        let resetAction = UIAlertAction(title: "Reset", style: .default, handler: { (action: UIAlertAction) in
            
            if let emailTextField = alertController.textFields?[0], let email = emailTextField.text
            {
                self.account.resetPassword(forEmail: email)
            }
        })

        alertController.addTextField { (textField: UITextField) in
            
            textField.placeholder = "Email"
            
            NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using: { (notification: Notification) in
                
                resetAction.isEnabled = textField.text != nil && !textField.text!.isEmpty
            })
        }
        
        alertController.addAction(resetAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        currentViewController.present(alertController, animated: true, completion: nil)
    }
}
