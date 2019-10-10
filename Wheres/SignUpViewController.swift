//
//  SignUpViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextViewDelegate
{
    //-------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //-------------------------------------------------------------------------
    
    @IBOutlet weak var fullNameTextInput: UITextField!
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var disclaimerTextView: UITextView!
    
    var viewModel:AuthViewModel!
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //-------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.disclaimerTextView.delegate = self
        
        let centeredParagraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center;
        
        let disclaimerString:NSMutableAttributedString =
            NSMutableAttributedString(
                string: "By signing up here you agree to our\nTerms of Use and Privacy Policy",
                attributes:
                convertToOptionalNSAttributedStringKeyDictionary([
                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle) : centeredParagraphStyle
                ]));
        
        disclaimerString.addAttributes(
            convertToNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.greenOlivine
            ]),
            range: NSRange(location: 0, length: 35));
        
        disclaimerString.addAttributes(
            convertToNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.link) : NSURL(string: WheresTermsOfUseLink)!
            ]),
            range: NSRange(location: 36, length: 12));
        
        disclaimerString.addAttributes(
            convertToNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.greenOlivine
            ]),
            range: NSRange(location: 49, length: 3));
        
        disclaimerString.addAttributes(
            convertToNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.link) : NSURL(string: WheresPrivacyPolicyLink)!
            ]),
            range: NSRange(location: 53, length: 14));
        
        self.disclaimerTextView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor.blueMalibu])
        
        self.disclaimerTextView.attributedText = disclaimerString;
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
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Delegates
    //
    //-------------------------------------------------------------------------
    
    //------------------------------------
    //  MARK: Gestures
    //------------------------------------
    
    @objc func handleTap()
    {
        self.fullNameTextInput.resignFirstResponder()
        self.emailTextInput.resignFirstResponder()
        self.passwordTextInput.resignFirstResponder()
    }
    
    //-------------------------------------
    //  MARK: - UITextViewDelegate
    //-------------------------------------
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    {
        if textView == self.disclaimerTextView
        {
            return true;
        }
        
        return false
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
