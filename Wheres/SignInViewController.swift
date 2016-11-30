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
    
    func showMainScreen()
    {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            appDelegate.showMainScreen()
        }
    }
    
    //------------------------------------
    //  MARK: Actions
    //------------------------------------
    
    @IBAction func signInButtonTapped(_ sender: Any)
    {
        if let email = usernameTextField.text, let password = passwordTextField.text
        {
            self.viewModel.signIn(withEmail: email, password: password)
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any)
    {
    }
}
