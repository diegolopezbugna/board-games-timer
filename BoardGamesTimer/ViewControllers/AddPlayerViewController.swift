//
//  AddPlayerViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 16/2/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

protocol AddPlayerViewControllerDelegate: class {
    func adedOrUpdatedPlayer(_ player: Player)
}

class AddPlayerViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var bggUserTextField: UITextField!
    
    weak var delegate: AddPlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        let player = Player(name: name, bggUser: bggUserTextField.text)
        Player.addOrUpdatePlayer(player)
        self.delegate?.adedOrUpdatedPlayer(player)
        self.navigationController?.popViewController(animated: true)
    }
}
