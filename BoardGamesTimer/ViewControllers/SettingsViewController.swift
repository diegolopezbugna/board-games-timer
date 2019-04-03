//
//  SettingsViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 2/4/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.usernameTextField.addTarget(self, action: #selector(self.usernameEditingEnd), for: .editingDidEnd)
        self.usernameTextField.addTarget(self, action: #selector(self.usernameEditingEnd), for: .editingDidEndOnExit)

        self.usernameTextField.text = UserDefaults.standard.value(forKey: UserDefaults.Keys.bggUsername.rawValue) as? String
    }
    
    @objc func usernameEditingEnd() {
        UserDefaults.standard.set(usernameTextField.text, forKey: UserDefaults.Keys.bggUsername.rawValue)
    }
}
