//
//  ViewController.swift
//  FirebaseLesson
//
//  Created by Андрей Колесников on 13.10.2021.
//

import UIKit

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
        return tf
    }()
    
    private let passwordField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Password"
        tf.layer.borderWidth = 1
        tf.isSecureTextEntry = true
        tf.layer.borderColor = UIColor.black.cgColor
        return tf
    }()
    
    private let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(passwordField)
        view.addSubview(emailField)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
        
        button.frame = CGRect(x: 20,
                              y: passwordField.frame.origin.y + passwordField.frame.size.height + 30,
                              width: view.frame.size.width - 40,
                              height: 52)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    @objc func didTapButton() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
                  print("Missing field data")
                  return
              }
    }
}

