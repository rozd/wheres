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
import SVProgressHUD

extension Notification.Name
{
    public static let AccountUserDidLogin = Notification.Name("AccountUserDidLogin")
    public static let AccountUserDidLogout = Notification.Name("AccountUserDidLogout")
}

/**
 * Responsible for all business logic related to current user, 
 * register/login/logout/change profile
 */
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
        
        // Listen for current user change and dispatch corresponded notification
        
        _stateChangeHandler = auth.addStateDidChangeListener({ (auth: Auth, user: FirebaseAuth.User?) in
            
            self.currentUser = user
        })
    }
    
    deinit
    {
        if _stateChangeHandler != nil
        {
            auth.removeStateDidChangeListener(_stateChangeHandler!);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Variables
    //
    //--------------------------------------------------------------------------
    
    private var auth = Auth.auth()
    
    private lazy var storage = Storage.storage().reference(forURL: WheresFirebaseStorageURL)
    
    private lazy var database = Database.database().reference()
    
    private lazy var service: AccountService = {

        return AccountService(storage: self.storage, database: self.database)
    }()
    
    private var _stateChangeHandler:AuthStateDidChangeListenerHandle?

    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------

    @objc dynamic var currentUser: FirebaseAuth.User?
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
        SVProgressHUD.show()

        auth.signIn(withEmail: email, password: password) { (result, error) in
            SVProgressHUD.dismiss()
            guard let user = result?.user else {
                if let errorMessage = error?.localizedDescription {
                    self.showMessage(message: errorMessage, withTitle: "Error")
                } else {
                    self.showMessage(message: "Could not to login you due to unknown error", withTitle: "Error")
                }
                return
            }
            self.currentUser = user
        }
    }
    
    func signIn(withCredential credential: AuthCredential)
    {
        auth.signIn(with: credential) { (result, error) in
            guard let user = result?.user else {
                if let errorMessage = error?.localizedDescription {
                    self.showMessage(message: errorMessage, withTitle: "Error")
                } else {
                    self.showMessage(message: "Could not to login you due to unknown error", withTitle: "Error")
                }
                return
            }
            self.currentUser = user
        }
    }
    
    func signUp(_ email:String, password:String, displayName: String?)
    {
        SVProgressHUD.show()

        auth.createUser(withEmail: email, password: password) { (result, error) in
            SVProgressHUD.dismiss()

            guard let user = result?.user else {
                if let errorMessage = error?.localizedDescription {
                    self.showMessage(message: errorMessage, withTitle: "Error")
                } else {
                    self.showMessage(message: "Could not to create an account due to unknown error.", withTitle: "Error")
                }
                return
            }

            self.currentUser = user

            // User signed up by email so they doesn't have avatar, generate it for them

            if let tempAvatar = Identicon().icon(from: email, size: CGSize(width: 640, height: 640), backgroundColor: UIColor.white) {
                self.changeAvatar(newAvatar: tempAvatar)
            }

            // save display name in database if specified

            if let displayName = displayName {
                self.updateProfileWith(newDisplayName: displayName)
            }
        }
    }
    
    func signOut()
    {
        do
        {
            try auth.signOut()
        }
        catch let error as NSError
        {
            showMessage(message: error.localizedDescription, withTitle: "Error")
        }
    }
    
    func resetPassword(forEmail email: String)
    {
        SVProgressHUD.show()

        auth.sendPasswordReset(withEmail: email, completion: { (error: Error?) in
            
            SVProgressHUD.dismiss()

            if error == nil
            {
                self.showMessage(message: "A password reset link was sent. Please check your email for further steps.", withTitle: "Confirmation")
            }
            else
            {
                
                self.showMessage(message: error!.localizedDescription, withTitle: "Error")
            }
        })
    }
    
    //-------------------------------------
    //  Methods: Profile
    //-------------------------------------

    func changeAvatar(newAvatar image: UIImage)
    {
        guard let currentUser = auth.currentUser else {
            return
        }
        
        guard let middleAvatar = UIImageRoutines.image(image, scaledTo: CGSize(width: WheresAvatarMiddleSize, height: WheresAvatarMiddleSize)) else {
            return
        }
        
        guard let smallAvatar = UIImageRoutines.image(image, scaledTo: CGSize(width: WheresAvatarSmallSize, height: WheresAvatarSmallSize)) else {
            return
        }
        
        guard let extraSmallAvatar = UIImageRoutines.image(image, scaledTo: CGSize(width: WheresAvatarExtraSmallSize, height: WheresAvatarExtraSmallSize)) else {
            return
        }
        
        // next update function uploads avatar and also updates current user's photoURL
        
        self.service.update(avatar: middleAvatar, withName: "middle", forUser: currentUser) { (avatarURL:URL?, error:Error?) in

            if error != nil
            {
                self.showMessage(message: error!.localizedDescription, withTitle: "Error")
                
                // Back to previos photo
                
                self.currentUser?.willChangeValue(forKey: "profileURL")
                self.currentUser?.didChangeValue(forKey: "profileURL")
            }
        }
        
        self.service.upload(avatar: smallAvatar, withName: "small", forUser: currentUser)
        self.service.upload(avatar: extraSmallAvatar, withName: "extraSmall", forUser: currentUser)
    }
    
    func updateProfileWith(newDisplayName displayName: String)
    {
        guard let currentUser = auth.currentUser else {
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
    
    func showMessage(message: String, withTitle title: String)
    {
        if let currentViewController = UIAlertControllerRoutines.findTopmostViewController()
        {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            currentViewController.present(controller, animated: true, completion: nil)
        }
    }
}
