//
//  PlayerSelector.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 17/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit
import PureLayout

class PlayerSelectorControl: UIControl {

    var leftButton: UIButton!
    var rightButton: UIButton!
    var label: UILabel!
    
    var players = Player.allSorted()
    var selectedPlayer: Player? {
        didSet {
            self.label.text = self.selectedPlayer?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    private func setupViews() {
        self.leftButton = self.createButton()
        self.addSubview(self.leftButton)
        self.leftButton.autoSetDimension(.width, toSize: 24)
        self.leftButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .right)
        
        self.rightButton = self.createButton()
        self.addSubview(self.rightButton)
        self.rightButton.autoSetDimension(.width, toSize: 24)
        self.rightButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .left)

        self.label = UILabel()
        self.addSubview(self.label)
        self.label.autoPinEdge(toSuperviewEdge: .top)
        self.label.autoPinEdge(toSuperviewEdge: .bottom)
        self.label.autoPinEdge(.left, to: .right, of: self.leftButton)
        self.label.autoPinEdge(.right, to: .left, of: self.rightButton)
        
        self.leftButton.setTitle("<", for: .normal)
        self.leftButton.addTarget(self, action: #selector(self.leftTapped), for: .touchUpInside)
        self.rightButton.setTitle(">", for: .normal)
        self.rightButton.addTarget(self, action: #selector(self.rightTapped), for: .touchUpInside)
    }

    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return button
    }
    
    @objc func leftTapped() {
        guard let lastPlayer = self.players.last else { return }
        if let p = self.selectedPlayer, let i = self.players.firstIndex(of: p) {
            self.selectedPlayer = i > 0 ? self.players[i-1] : lastPlayer
        } else {
            self.selectedPlayer = lastPlayer
        }
    }

    @objc func rightTapped() {
        guard let firstPlayer = self.players.first else { return }
        if let p = self.selectedPlayer, let i = self.players.firstIndex(of: p) {
            self.selectedPlayer = p == self.players.last ? firstPlayer : self.players[i+1]
        } else {
            self.selectedPlayer = firstPlayer
        }
    }
}
