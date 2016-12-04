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

class AccountService
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - LIfecycle
    //
    //--------------------------------------------------------------------------
    
    init(storage: FIRStorageReference, database: FIRDatabaseReference)
    {
        self.storage = storage
        self.database = database
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    let storage: FIRStorageReference
    let database: FIRDatabaseReference
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    func update(avatar image: UIImage, withName name: String, forUser user:FIRUser)
    {
        self.update(avatar: image, withName: name, forUser: user, completion: nil)
    }
    
    /**
     * @param completion
     */
    func update(avatar image: UIImage, withName name: String, forUser user:FIRUser, completion: ((URL?, Error?) -> Void)?)
    {
        self.upload(avatar: image, withName: name, forUser: user, completion: { (url: URL?, error: Error?) -> Void in
            
            if let url = url
            {
                let changeRequest = user.profileChangeRequest()
                
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
    
    func upload(avatar image: UIImage, withName name: String, forUser user:FIRUser)
    {
        self.upload(avatar: image, withName: name, forUser: user, completion: nil)
    }
    
    func upload(avatar image: UIImage, withName name: String, forUser user:FIRUser, completion: ((URL?, Error?) -> Void)?)
    {
        DispatchQueue.global(qos: .background).async {
            
            guard let imageData = UIImagePNGRepresentation(image) else {
                
                DispatchQueue.main.async {
                    
                    completion?(nil, NSError(domain: "WheresErrorDomain", code: -1, userInfo: ["NSLocalizedDescriptionKey" : "Could not create image data from specified image."]))
                }
                
                return
            }
            
            let avatarRef = self.storage.child("users/\(user.uid)/public-data/avatar/\(name)")
            
            let _ = avatarRef.put(imageData, metadata: FIRStorageMetadata(dictionary: ["contentType" : "image/png"])) { (outputMetadata: FIRStorageMetadata?, error:Error?) in

                if let url = outputMetadata?.downloadURL()
                {
                    // save also in the Database
                    
                    self.database.child("users/\(user.uid)/\(name)AvatarPath").setValue(url.absoluteString)
                }
                
                DispatchQueue.main.async {
                    
                    completion?(outputMetadata?.downloadURL(), error)
                }
            }
        }
    }
    
    func update(displayName newDisplayName: String, forUser user: FIRUser, completion: ((Error?) -> Void)?)
    {
        let changeRequest = user.profileChangeRequest()
        
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
