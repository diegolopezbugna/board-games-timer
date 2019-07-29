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
    @IBOutlet private var mainTextView: UITextView!
    
    private var getBggUsernameUseCase: GetBggUsernameUseCaseProtocol
    private var saveBggUsernameUseCase: SaveBggUsernameUseCaseProtocol

    required init?(coder aDecoder: NSCoder) {
        let provider = BggUsernameProvider()
        getBggUsernameUseCase = GetBggUsernameUseCase(bggUsernameProvider: provider)
        saveBggUsernameUseCase = SaveBggUsernameUseCase(bggUsernameProvider: provider)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        usernameTextField.addTarget(self, action: #selector(self.usernameEditingEnd), for: .editingDidEnd)
        usernameTextField.addTarget(self, action: #selector(self.usernameEditingEnd), for: .editingDidEndOnExit)

        getBggUsernameUseCase.completionSuccess = { (bggUsername: String?) in
            self.usernameTextField.text = bggUsername
        }
        getBggUsernameUseCase.execute()
        
        mainTextView.text = "Board Games Timer connects with Board Game Geek to get user logged plays. \n\nIn a near future, Board Games Timer saved plays will be syncronized with BGG logged plays!".localized
    }
    
    @objc func usernameEditingEnd() {
        saveBggUsernameUseCase.execute(bggUsername: usernameTextField.text)
    }
}
