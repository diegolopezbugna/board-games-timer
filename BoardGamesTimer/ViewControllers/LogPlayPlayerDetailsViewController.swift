//
//  LogPlayPlayerDetailsViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 10/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

protocol LogPlayPlayerDetailsDelegate: class {
    func detailsDismissed(playerDetails: PlayPlayerDetails?)
}

class LogPlayPlayerDetailsViewController: UIViewController {
    
    @IBOutlet var playerSelectorControl: PlayerSelectorControl!
    @IBOutlet var wonSwitch: UISwitch!
    @IBOutlet var scoreTextField: UITextField!
    @IBOutlet var teamColorTextField: UITextField!
    @IBOutlet var startingPositionTextField: UITextField!
    @IBOutlet var playRatingTextField: UITextField!
    @IBOutlet var firstTimePlaying: UISwitch!
    
    weak var delegate: LogPlayPlayerDetailsDelegate?
    var playerDetails: PlayPlayerDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.popoverPresentationController?.delegate = self
        
        if let d = playerDetails {
            playerSelectorControl.selectedPlayer = d.player
            wonSwitch.isOn = d.won ?? false
            scoreTextField.text = d.score != nil ? String(d.score!) : ""
            teamColorTextField.text = d.teamColor
            startingPositionTextField.text = d.startingPosition
            playRatingTextField.text = d.playRating
            firstTimePlaying.isOn = d.firstTimePlaying ?? false
        }
    }
}

extension LogPlayPlayerDetailsViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if let player = playerSelectorControl.selectedPlayer {
            let playerDetails = self.playerDetails ?? PlayPlayerDetails()
            playerDetails.player = player
            playerDetails.won = wonSwitch.isOn
            playerDetails.firstTimePlaying = firstTimePlaying.isOn
            playerDetails.score =  Int(scoreTextField.text ?? "")
            playerDetails.teamColor = teamColorTextField.text
            playerDetails.startingPosition = startingPositionTextField.text
            playerDetails.playRating = playRatingTextField.text
            self.delegate?.detailsDismissed(playerDetails: playerDetails)
        }
    }
}
