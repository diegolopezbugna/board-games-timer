//
//  ColorSelectorViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/23/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class ColorSelectorViewController: UIViewController {
    var selectedColorIndex: Int! {
        didSet {
            colorView.backgroundColor = availableColors[selectedColorIndex].bgColor
        }
    }
    var availableColors: [PlayerColor]!

    convenience init(availableColors: [PlayerColor], selectedColorIndex: Int) {
        self.init()
        self.availableColors = availableColors
        self.selectedColorIndex = selectedColorIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = 1.0
        colorView.backgroundColor = availableColors[selectedColorIndex].bgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var colorView: UIView!
    
    @IBAction func leftTap(_ sender: Any) {
        if (selectedColorIndex > 0) {
            selectedColorIndex = selectedColorIndex - 1
        }
    }
    
    @IBAction func rightTap(_ sender: Any) {
        if (selectedColorIndex < availableColors.count - 1) {
            selectedColorIndex = selectedColorIndex + 1
        }
    }
    
}
