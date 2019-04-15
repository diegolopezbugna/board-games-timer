//
//  ColorSelectorControl.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 15/4/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit
import PureLayout

class ColorSelectorControl: UIControl {
    
    private var leftButton: UIButton!
    private var rightButton: UIButton!
    private var colorView: UIView!
    
    var selectedColorIndex: Int = 0 {
        didSet {
            self.colorView.backgroundColor = self.availableColors[self.selectedColorIndex].bgColor
        }
    }
    var availableColors = [PlayerColor]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    convenience init(availableColors: [PlayerColor], selectedColorIndex: Int) {
        self.init()
        self.availableColors = availableColors
        self.selectedColorIndex = selectedColorIndex
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
        
        self.colorView = UIView()
        self.addSubview(self.colorView)
        self.colorView.autoPinEdge(toSuperviewEdge: .top)
        self.colorView.autoPinEdge(toSuperviewEdge: .bottom)
        self.colorView.autoPinEdge(.left, to: .right, of: self.leftButton)
        self.colorView.autoPinEdge(.right, to: .left, of: self.rightButton)
        
        self.colorView.layer.borderColor = UIColor.black.cgColor
        self.colorView.layer.borderWidth = 1.0
        self.colorView.backgroundColor = self.availableColors[selectedColorIndex].bgColor
        
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
        if (self.selectedColorIndex > 0) {
            self.selectedColorIndex = self.selectedColorIndex - 1
        }
    }
    
    @objc func rightTapped() {
        if (self.selectedColorIndex < self.availableColors.count - 1) {
            self.selectedColorIndex = self.selectedColorIndex + 1
        }
    }
}
