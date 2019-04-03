//
//  ColorSelectorViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/23/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class ColorSelectorViewController: UIViewController {

    @IBOutlet var colorView: UIView!

    var selectedColorIndex: Int! {
        didSet {
            colorView.backgroundColor = availableColors[selectedColorIndex].bgColor
        }
    }
    private var availableColors: [PlayerColor]!
    
    convenience init(availableColors: [PlayerColor], selectedColorIndex: Int) {
        self.init()
        self.availableColors = availableColors
        self.selectedColorIndex = selectedColorIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorView.layer.borderColor = UIColor.black.cgColor
        self.colorView.layer.borderWidth = 1.0
        self.colorView.backgroundColor = self.availableColors[selectedColorIndex].bgColor
    }
    
    @IBAction func leftTap(_ sender: Any) {
        if (self.selectedColorIndex > 0) {
            self.selectedColorIndex = self.selectedColorIndex - 1
        }
    }
    
    @IBAction func rightTap(_ sender: Any) {
        if (self.selectedColorIndex < self.availableColors.count - 1) {
            self.selectedColorIndex = self.selectedColorIndex + 1
        }
    }
    
    
}
