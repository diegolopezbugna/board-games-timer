//
//  PositionHeaderTableViewCell.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 5/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit
import PureLayout

class PositionHeaderTableViewCell: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .horizontal
        stackView.distribution = .fill
        self.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
        let positionLabel = self.createLabel()
        positionLabel.text = "#"
        stackView.addArrangedSubview(positionLabel)
        positionLabel.autoSetDimension(.width, toSize: 40)
        let colorLabel = self.createLabel()
        colorLabel.text = "Color"
        stackView.addArrangedSubview(colorLabel)
        colorLabel.autoSetDimension(.width, toSize: 80)
        let playerLabel = self.createLabel()
        playerLabel.text = "Player"
        stackView.addArrangedSubview(playerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel() -> UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }
    
}
