//
//  PlayTableViewCell.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 18/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class PlayTableViewCell: UITableViewCell {

    var day: UILabel!
    var gameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.day = UILabel(forAutoLayout: ())
        self.day.font = UIFont.boldSystemFont(ofSize: 17)
        self.addSubview(self.day)
        self.day.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0), excludingEdge: .right)
        
        self.gameLabel = UILabel(forAutoLayout: ())
        self.gameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.addSubview(self.gameLabel)
        self.gameLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 16), excludingEdge: .left)
        self.gameLabel.autoPinEdge(.left, to: .right, of: self.day, withOffset: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
