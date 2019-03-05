//
//  PositionHeaderTableViewCell.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 5/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class PositionHeaderTableViewCell: UITableViewHeaderFooterView {
    
//    var positionLabel: UILabel!
//    var colorLabel: UILabel!
//    var playerLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        self.addSubview(stackView)
        // TODO: constraints
        let positionLabel = self.createLabel()
        positionLabel.text = "#"
        stackView.addArrangedSubview(positionLabel)
        let colorLabel = self.createLabel()
        colorLabel.text = "Color"
        stackView.addArrangedSubview(colorLabel)
        let playerLabel = self.createLabel()
        playerLabel.text = "Player"
        stackView.addArrangedSubview(playerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }
    
}
