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
    
    var stackView: UIStackView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.stackView = UIStackView(forAutoLayout: ())
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.addSubview(stackView)
        self.stackView.autoPinEdgesToSuperviewEdges()

        self.addColumnTitle("Color", width: 80)
        self.addColumnTitle("Time", width: 80)
        self.addColumnTitle("Player", width: 80)
        self.addColumnTitle("Points", width: 80)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addColumnTitle(_ title: String, width: CGFloat) {
        let label = self.createLabel()
        label.text = title
        self.stackView.addArrangedSubview(label)
//        label.autoSetDimension(.width, toSize: width)
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }
    
}
