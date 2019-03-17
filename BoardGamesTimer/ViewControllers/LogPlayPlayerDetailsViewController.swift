//
//  LogPlayPlayerDetailsViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 10/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

protocol LogPlayPlayerDetailsDelegate: class {
    func detailsDismissed(playerDetails: PlayerDetails?)
}

struct PlayerDetails {
    let player: Player
    let won: Bool?
    let score: Int?
    let teamColor: String?
    let startingPosition: String?
    let playRating: String?
}

class LogPlayPlayerDetailsViewController: UIViewController {
    
    @IBOutlet var playerSelectorControl: PlayerSelectorControl!
    @IBOutlet var wonSwitch: UISwitch!
    @IBOutlet var scoreTextField: UITextField!
    @IBOutlet var teamColorTextField: UITextField!
    @IBOutlet var startingPositionTextField: UITextField!
    @IBOutlet var playRatingTextField: UITextField!
    
    weak var delegate: LogPlayPlayerDetailsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.popoverPresentationController?.delegate = self
    }
}

extension LogPlayPlayerDetailsViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if let player = playerSelectorControl.selectedPlayer {
            let playerDetails = PlayerDetails(player: player, won: wonSwitch.isOn, score: Int(scoreTextField.text ?? ""), teamColor: teamColorTextField.text, startingPosition: startingPositionTextField.text, playRating: playRatingTextField.text)
            self.delegate?.detailsDismissed(playerDetails: playerDetails)
        }
    }
}
