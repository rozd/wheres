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
    
    var viewModel:AuthViewModel!
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //-------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        guard let email = emailTextInput.text, let password = passwordTextInput.text, !email.isEmpty, !password.isEmpty else {
            
            showMessage(message: "Please fill both email and password", withTitle: "Info")
            return
        }
        
        self.viewModel.signUp(withEmail: email, password: password, displayName: fullNameTextInput.text)
    }
}
