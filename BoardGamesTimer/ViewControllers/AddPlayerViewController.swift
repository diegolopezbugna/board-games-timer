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
    @IBOutlet var titleLabel: UILabel!
    
    var player: Player?
    weak var delegate: AddPlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let player = player {
            self.nameTextField.text = player.name
            self.bggUserTextField.text = player.bggUsername
            self.title = "Edit Player".localized
            self.titleLabel.text = "Edit Player".localized
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        var player = self.player
        if player != nil {
            player!.name = name
            player!.bggUsername = bggUserTextField.text
        } else {
            player = Player(id: UUID(), name: name, bggUsername: bggUserTextField.text)
        }
        Player.addOrUpdatePlayer(player!)
        self.delegate?.adedOrUpdatedPlayer(player!)
        self.navigationController?.popViewController(animated: true)
    }
}
