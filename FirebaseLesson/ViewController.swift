//
//  ViewController.swift
//  FirebaseLesson
//
//  Created by Андрей Колесников on 13.10.2021.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()

//    private let passwordLabel: UILabel = {
//       let label = UILabel()
//        label.textAlignment = .center
//        label.text = "Log In"
//        label.font = .systemFont(ofSize: 24, weight: .semibold)
//        return label
//    }()
    
    private let emailField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Email Adress"
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.leftViewMode = .always
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return tf
    }()
    
    private let passwordField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Password"
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.leftViewMode = .always
        tf.layer.borderWidth = 1
        tf.isSecureTextEntry = true
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.leftViewMode = .always
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return tf
    }()
    
    private let signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let signOutButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("SignOut", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(label)
        view.addSubview(signInButton)
        view.addSubview(passwordField)
        view.addSubview(emailField)
        
        signInButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            self.label.isHidden = true
            self.emailField.isHidden = true
            self.passwordField.isHidden = true
            self.signInButton.isHidden = true
            self.emailField.resignFirstResponder()
            self.passwordField.resignFirstResponder()
            
            view.addSubview(signOutButton)
            signOutButton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 52)
            signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        }
    }
    
    @objc func logOutTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            self.label.isHidden = false
            self.emailField.isHidden = false
            self.passwordField.isHidden = false
            self.signInButton.isHidden = false
            self.emailField.resignFirstResponder()
            self.passwordField.resignFirstResponder()
            
            signOutButton.removeFromSuperview()
            
        } catch {
            print("signing out failed")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 0,
                             y: 100,
                             width: view.frame.size.width,
                             height: 80)
        
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y + label.frame.size.height + 10,
                                  width: view.frame.size.width - 40,
                                  height: 50)
        
        
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.frame.origin.y + emailField.frame.size.height + 10,
                                     width: view.frame.size.width - 40,
                                     height: 50)
        
        signInButton.frame = CGRect(x: 20,
                              y: passwordField.frame.origin.y + passwordField.frame.size.height + 30,
                              width: view.frame.size.width - 40,
                              height: 52)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailField.becomeFirstResponder()
        }
    }
    
    @objc func didTapContinueButton() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
                  print("Missing field data")
                  return
              }
        
        // try ro sign in in Firebase
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                // show account creation
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            
            print("Log in succeded")
            strongSelf.label.isHidden = true
            strongSelf.emailField.isHidden = true
            strongSelf.passwordField.isHidden = true
            strongSelf.signInButton.isHidden = true
            strongSelf.signOutButton.isHidden = false
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
        }
    }
    
    func showCreateAccount(email: String, password: String) {
        let alertController = UIAlertController(title: "Create account", message: "Would you like to create an account?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
                guard let strongSelf = self else { return }
                
                guard error == nil else {
                    // show account creation
                    print("Account creation Failed")
                    return
                }
                
                print("Log in succeded")
                strongSelf.label.isHidden = true
                strongSelf.emailField.isHidden = true
                strongSelf.passwordField.isHidden = true
                strongSelf.signInButton.isHidden = true
                strongSelf.emailField.resignFirstResponder()
                strongSelf.passwordField.resignFirstResponder()
            }
            
        }))
        
        alertController.addAction (UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        present(alertController, animated: true)
    }
}

