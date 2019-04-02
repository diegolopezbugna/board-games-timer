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
    }
}
