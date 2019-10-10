//
//  ProfileViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Lifecycle
    //
    //--------------------------------------------------------------------------
    
    deinit
    {
        print("ProfileViewController.deinit")
        
        self.viewModel.account.removeObserver(self, forKeyPath: "currentUser")
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var viewModel: AuthViewModel!
    
    private var isSignedOut: Bool = false

    //--------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //--------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.isSignedOut = false
        
        let borderLayer = CALayer();
        borderLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.avatarImageView.bounds.width, height: self.avatarImageView.bounds.height)
        borderLayer.cornerRadius = CGFloat(self.avatarImageView.bounds.width / 2.0);
        borderLayer.borderWidth = 4.0;
        borderLayer.borderColor = UIColor.redCadmium.cgColor
        
        self.avatarImageView.layer.addSublayer(borderLayer);
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(avatarImageViewTapped(_:)))
        self.avatarImageView.isUserInteractionEnabled = true
        self.avatarImageView.addGestureRecognizer(tapGestureRecogniser)
        
        self.viewModel.account.addObserver(self, forKeyPath: "currentUser", options: .initial, context: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    func showImagePicker(forTakingNewImage takeNewPicture:Bool)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = takeNewPicture ? .camera : .photoLibrary;
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func refreshAvatar()
    {
        guard !isSignedOut else {
            return
        }
        
        if let userPictureURL = self.viewModel.account.currentUser?.photoURL
        {
            DispatchQueue.global(qos: .background).async {
                
                do
                {
                    let imageData = try Data(contentsOf: userPictureURL)
                    
                    if let image = UIImage(data: imageData)
                    {
                        DispatchQueue.main.async {
                            
                            self.avatarImageView.image = image;
                        }
                    }
                }
                catch let error
                {
                    self.showMessage(message: error.localizedDescription, withTitle: "Error")
                }
            }
        }
    }
    
    func refreshDisplayName()
    {
        self.usernameLabel.text = self.viewModel.account.currentUser?.displayName
    }
    
    //-------------------------------------
    //  MARK: Alerts
    //-------------------------------------
    
    private func showMessage(message: String, withTitle title: String)
    {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //-------------------------------------
    //  MARK: Actions
    //-------------------------------------
    
    @objc func avatarImageViewTapped(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Change avatar", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Take New Picture", style: .default, handler: {(action: UIAlertAction) in
            
            self.showImagePicker(forTakingNewImage: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Select From Photos", style: .default, handler: {(action: UIAlertAction) in
            
            self.showImagePicker(forTakingNewImage: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func signOutButtonTapped(_ sender: Any)
    {
        isSignedOut = true
        
        self.viewModel.signOut()
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Delegates
    //
    //--------------------------------------------------------------------------
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let avatarImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        {
            self.avatarImageView.image = avatarImage
            
            self.viewModel.changeAvatar(newAvatar: avatarImage)
        }
            
        self.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------
    //  MARK: - KVO
    //-------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let keyPath = keyPath, keyPath == "currentUser"
        {
            refreshAvatar()
            refreshDisplayName()
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
