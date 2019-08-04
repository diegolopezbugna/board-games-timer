//
//  LogPlayPlayerDetailsViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 10/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

protocol LogPlayPlayerDetailsDelegate: class {
    func detailsDismissed(playerDetails: LoggedPlayPlayerDetails?)
}

class LogPlayPlayerDetailsViewController: UIViewController, PlayerSelectorControlDatasource {
    
    @IBOutlet private var playerSelectorControl: PlayerSelectorControl!
    @IBOutlet private var wonSwitch: UISwitch!
    @IBOutlet private var scoreTextField: UITextField!
    @IBOutlet private var teamColorTextField: UITextField!
    @IBOutlet private var startingPositionTextField: UITextField!
    @IBOutlet private var playRatingTextField: UITextField!
    @IBOutlet private var firstTimePlaying: UISwitch!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    weak var delegate: LogPlayPlayerDetailsDelegate?
    var playerDetails: LoggedPlayPlayerDetails?
    var players: [Player]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if let d = self.playerDetails {
            playerSelectorControl.selectedPlayer = d.player
            wonSwitch.isOn = d.won ?? false
            scoreTextField.text = d.score != nil ? String(d.score!) : ""
            teamColorTextField.text = d.teamColor
            startingPositionTextField.text = d.startingPosition
            playRatingTextField.text = d.playRating
            firstTimePlaying.isOn = d.firstTimePlaying ?? false
        }
        
        playerSelectorControl.datasource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardChangeFrameObserver(willShow: { [weak self] (height) in
            self?.view.frame.origin.y = -height / 2 // TODO: only move when bottom textfields are first responder
            self?.view.layoutIfNeeded()
            }, willHide: { [weak self] (height) in
                self?.view.frame.origin.y = 0
                self?.view.layoutIfNeeded()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardChangeFrameObserver()
        self.save()
    }

    private func save() {
        if let player = self.playerSelectorControl.selectedPlayer {
            let playerDetails = self.playerDetails ?? LoggedPlayPlayerDetails()
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
