//
//  SignUpViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController
{
    //-------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //-------------------------------------------------------------------------
    
    @IBOutlet weak var fullNameTextInput: UITextField!
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    
    weak var viewModel:AuthViewModel! // TODO: weak?
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //-------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //-------------------------------------------------------------------------
    
    func showMessage(message: String, withTitle title: String)
    {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(controller, animated: true, completion: nil)
    }
    
    //-------------------------------------
    //  MARK: Actions
    //-------------------------------------

    @IBAction func signUpButtonTapped(_ sender: Any)
    {
        if let email = self.emailTextInput.text, let password = self.passwordTextInput.text
        {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                if user != nil
                {
//                    self.currentUser = user
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
    }
}
