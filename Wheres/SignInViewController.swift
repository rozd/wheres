//
//  SignInViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController
{
    deinit
    {
        print("SignInViewController.deinit")
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //-------------------------------------------------------------------------
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel:AuthViewModel!
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //-------------------------------------------------------------------------
    
    // MARK: UIViewController
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let signUpViewController = segue.destination as? SignUpViewController
        {
            signUpViewController.viewModel = self.viewModel;
        }
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //-------------------------------------------------------------------------
    
    private func showMessage(message: String, withTitle title: String)
    {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //------------------------------------
    //  MARK: Gestures
    //------------------------------------
    
    func handleTap()
    {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    //------------------------------------
    //  MARK: Actions
    //------------------------------------
    
    @IBAction func signInButtonTapped(_ sender: Any)
    {
        guard let email = usernameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            
            showMessage(message: "Please fill both email and password", withTitle: "Info")
            return
        }

        self.viewModel.signIn(withEmail: email, password: password)
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any)
    {
        self.viewModel.forgotPassword()
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any)
    {
    }
}
