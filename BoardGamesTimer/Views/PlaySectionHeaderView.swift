//
//  PlaySectionHeaderView.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 18/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class PlaySectionHeaderView: UITableViewHeaderFooterView {
    var containerView: UIView!
    var monthLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.containerView = UIView(forAutoLayout: ())
        self.addSubview(self.containerView)
        self.containerView.autoPinEdgesToSuperviewEdges()
        self.containerView.backgroundColor = UIColor.orange
        self.monthLabel = UILabel(forAutoLayout: ())
        self.containerView.addSubview(self.monthLabel)
        self.monthLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        self.monthLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.monthLabel.textColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(text: String, textColor: UIColor, backgroundColor: UIColor) {
        self.monthLabel.text = text
        self.monthLabel.textColor = textColor
        self.containerView.backgroundColor = backgroundColor
    }
}
