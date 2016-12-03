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
        DispatchQueue.global(qos: .background).async {
            
            guard let imageData = UIImagePNGRepresentation(image) else {
                
                DispatchQueue.main.async {
                    
                    completion?(nil, NSError(domain: "WheresErrorDomain", code: -1, userInfo: ["NSLocalizedDescriptionKey" : "Could not create image data from specified image."]))
                }
                
                return
            }
            
            let avatarRef = self.storage.child("users/\(user.uid)/public-data/avatar/\(name)")
            
            let _ = avatarRef.put(imageData, metadata: FIRStorageMetadata(dictionary: ["contentType" : "image/png"])) { (outputMetadata: FIRStorageMetadata?, error:Error?) in
                
                DispatchQueue.main.async {
                    
                    if error == nil
                    {
                        let changeRequest = user.profileChangeRequest()
                        
                        changeRequest.photoURL = outputMetadata?.downloadURL()
                        
                        changeRequest.commitChanges(completion: { (error:Error?) in
                            
                            if error != nil
                            {
                                DispatchQueue.main.async {
                                    
                                    completion?(nil, error)
                                }
                            }
                        })
                        
                        // save also in the Database
                    
                        self.database.child("users/\(user.uid)/\(name)AvatarPath").setValue(changeRequest.photoURL?.absoluteString)
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            
                            completion?(nil, error)
                        }
                    }
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
