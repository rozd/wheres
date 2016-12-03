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
import FirebaseStorage
import FirebaseDatabase
import IGIdenticon

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
        
        _stateChangeHandler = auth?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            
            self.currentUser = user
        })
    }
    
    deinit
    {
        if _stateChangeHandler != nil
        {
            auth?.removeStateDidChangeListener(_stateChangeHandler!);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Variables
    //
    //--------------------------------------------------------------------------
    
    private var auth = FIRAuth.auth()
    
    private lazy var storage = FIRStorage.storage().reference(forURL: WheresFirebaseStorageURL)
    
    private lazy var database = FIRDatabase.database().reference()
    
    private lazy var service: AccountService = {

        return AccountService(storage: self.storage, database: self.database)
    }()
    
    private var _stateChangeHandler:FIRAuthStateDidChangeListenerHandle?

    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------

    dynamic var currentUser: FIRUser?
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
    //  Methods: Authentication
    //-------------------------------------
    
    func signIn(withEmail email: String, password: String)
    {
        auth?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
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
    
    func signUp(_ email:String, password:String, displayName: String?)
    {
        auth?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if user != nil
            {
                self.currentUser = user
                
                if let tempAvatar = Identicon().icon(from: email, size: CGSize(width: 640, height: 640))
                {
                    self.changeAvatar(newAvatar: tempAvatar)
                }
                
                if let displayName = displayName
                {
                    self.updateProfileWith(newDisplayName: displayName)
                }
            }
            else if let errorMessage = error?.localizedDescription
            {
                self.showMessage(message: errorMessage, withTitle: "Error")
            }
            else
            {
                self.showMessage(message: "Could not to create an account due to unknown error.", withTitle: "Error")
            }
        })
    }
    
    func signOut()
    {
        do
        {
            try auth?.signOut()
        }
        catch let error as NSError
        {
            showMessage(message: error.localizedDescription, withTitle: "Error")
        }
    }
    
    //-------------------------------------
    //  Methods: Profile
    //-------------------------------------

    func changeAvatar(newAvatar image: UIImage)
    {
        guard let currentUser = auth?.currentUser else {
            return
        }
        
        guard let middleAvatar = UIImageRoutines.image(image, scaledTo: CGSize(width: 256, height: 256)) else {
            return
        }
        
        guard let smallAvatar = UIImageRoutines.image(image, scaledTo: CGSize(width: 96, height: 96)) else {
            return
        }
        
        guard let extraSmallAvatar = UIImageRoutines.image(image, scaledTo: CGSize(width: 32, height: 32)) else {
            return
        }
        
        self.service.update(avatar: middleAvatar, withName: "middle", forUser: currentUser) { (avatarURL:URL?, error:Error?) in
            
            if error != nil
            {
                self.showMessage(message: error!.localizedDescription, withTitle: "Error")
                
                // Back to previos photo
                
                self.currentUser?.willChangeValue(forKey: "profileURL")
                self.currentUser?.didChangeValue(forKey: "profileURL")
            }
        }
        
        self.service.update(avatar: smallAvatar, withName: "small", forUser: currentUser)
        self.service.update(avatar: extraSmallAvatar, withName: "extraSmall", forUser: currentUser)
    }
    
    func updateProfileWith(newDisplayName displayName: String)
    {
        guard let currentUser = auth?.currentUser else {
            return
        }

        self.service.update(displayName: displayName, forUser: currentUser) { (error:Error?) -> Void in
            
            if error != nil
            {
                self.showMessage(message: error!.localizedDescription, withTitle: "Error")
                
                // Back to previos displayName
                
                self.currentUser?.willChangeValue(forKey: "displayName")
                self.currentUser?.didChangeValue(forKey: "displayName")
            }
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
