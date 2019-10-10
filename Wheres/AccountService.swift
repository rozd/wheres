//
//  AccountService.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/3/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

/**
 * Responsible for database and storage routines for current user, such as
 * upload avatar into storage and save link to database.
 */
class AccountService
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - LIfecycle
    //
    //--------------------------------------------------------------------------
    
    init(storage: StorageReference, database: DatabaseReference)
    {
        self.storage = storage
        self.database = database
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    let storage: StorageReference
    let database: DatabaseReference
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    func update(avatar image: UIImage, withName name: String, forUser user:FirebaseAuth.User)
    {
        self.update(avatar: image, withName: name, forUser: user, completion: nil)
    }
    
    // Uploads specified image into the storage and save it as avatar with specified @name into database
    // and also change photoURL for specified @user
    func update(avatar image: UIImage, withName name: String, forUser user:FirebaseAuth.User, completion: ((URL?, Error?) -> Void)?)
    {
        self.upload(avatar: image, withName: name, forUser: user, completion: { (url: URL?, error: Error?) -> Void in
            
            if let url = url
            {
                let changeRequest = user.createProfileChangeRequest()
                
                changeRequest.photoURL = url
                
                changeRequest.commitChanges(completion: { (error:Error?) in
                    
                    if error != nil
                    {
                        completion?(nil, error)
                    }
                    else
                    {
                        completion?(url, nil)
                    }
                })
            }
            else
            {
                completion?(nil, error)
            }
        })
    }
    
    func upload(avatar image: UIImage, withName name: String, forUser user:FirebaseAuth.User)
    {
        self.upload(avatar: image, withName: name, forUser: user, completion: nil)
    }
    
    // Uploads specified image into the storage and save it as avatar with specified @name into database
    func upload(avatar image: UIImage, withName name: String, forUser user:FirebaseAuth.User, completion: ((URL?, Error?) -> Void)?)
    {
        DispatchQueue.global(qos: .background).async {
            
            guard let imageData = image.pngData() else {
                
                DispatchQueue.main.async {
                    
                    completion?(nil, NSError(domain: "WheresErrorDomain", code: -1, userInfo: ["NSLocalizedDescriptionKey" : "Could not create image data from specified image."]))
                }
                
                return
            }
            
            let avatarRef = self.storage.child("users/\(user.uid)/public-data/avatar/\(name)")
            
            let _ = avatarRef.putData(imageData, metadata: StorageMetadata(dictionary: ["contentType" : "image/png"])) { (outputMetadata: StorageMetadata?, error:Error?) in

                guard error == nil else {
                    DispatchQueue.main.async {
                        completion?(nil, error)
                    }
                    return
                }

                avatarRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        DispatchQueue.main.async {
                            completion?(nil, error)
                        }
                        return
                    }

                    self.database.child("users/\(user.uid)/\(name)AvatarPath").setValue(downloadURL.absoluteString)

                    DispatchQueue.main.async {
                        completion?(downloadURL, error)
                    }
                }
            }
        }
    }
    
    func update(displayName newDisplayName: String, forUser user: FirebaseAuth.User, completion: ((Error?) -> Void)?)
    {
        let changeRequest = user.createProfileChangeRequest()
        
        changeRequest.displayName = newDisplayName
        
        changeRequest.commitChanges { (error: Error?) in
            
            if error == nil
            {
                // also update in users database
                
                self.database.child("users/\(user.uid)/displayName").setValue(newDisplayName)
            }
            
            completion?(error)
        }
    }
}
