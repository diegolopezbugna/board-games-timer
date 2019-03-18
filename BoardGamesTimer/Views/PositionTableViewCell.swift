//
//  PositionTableViewCell.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 4/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    
    var colorLabel: UILabel!
    var playerLabel: UILabel!
    var scoreLabel: UILabel!
    let players = Player.allSorted()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 52))
        
        self.colorLabel = self.createLabel()
        stackView.addArrangedSubview(self.colorLabel)
        self.colorLabel.autoSetDimension(.width, toSize: 80)
        
        self.playerLabel = self.createLabel()
        stackView.addArrangedSubview(self.playerLabel)
        self.playerLabel.autoSetDimension(.width, toSize: 80)
        
        self.scoreLabel = self.createLabel()
        stackView.addArrangedSubview(self.scoreLabel)
        self.scoreLabel.autoSetDimension(.width, toSize: 80)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel() -> UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField(forAutoLayout: ())
        textField.textAlignment = .center
        textField.borderStyle = .bezel
        return textField
    }

}
