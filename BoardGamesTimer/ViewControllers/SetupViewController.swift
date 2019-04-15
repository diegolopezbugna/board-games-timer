//
//  SetupViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/15/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

struct PlayerColor {
    var name: String
    var textColor: UIColor
    var bgColor: UIColor
    var bgColor2: UIColor
}

class SetupViewController: UIViewController {

    @IBOutlet private var initialTimeLabel: UILabel!
    @IBOutlet private var initialTimeStepper: UIStepper!
    @IBOutlet private var turnTimeLabel: UILabel!
    @IBOutlet private var turnTimeStepper: UIStepper!
    
    @IBOutlet private var playersLabel: UILabel!
    @IBOutlet private var playersStepper: UIStepper!
    @IBOutlet private var colorSelectorsView: UIView!
    @IBOutlet private var colorSelectors2View: UIView!
    
    private var colorSelectors = [ColorSelectorControl]()

    static let availableColors = [
        PlayerColor(name: "Red", textColor: UIColor.white, bgColor: UIColor(red: 0.6, green: 0, blue: 0), bgColor2: UIColor(red: 1, green: 0, blue: 0)),
        PlayerColor(name: "Green", textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0.5, blue: 0), bgColor2: UIColor(red: 0, green: 0.9, blue: 0)),
        PlayerColor(name: "Blue", textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0, blue: 0.6), bgColor2: UIColor(red: 0.3, green: 0.3, blue: 1)),
        PlayerColor(name: "Yellow", textColor: UIColor.black, bgColor: UIColor.yellow, bgColor2: UIColor(red: 0.6, green: 0.6, blue: 0)),
        PlayerColor(name: "Black", textColor: UIColor.white, bgColor: UIColor.black, bgColor2: UIColor(red: 0.4, green: 0.4, blue: 0.4)),
        PlayerColor(name: "White", textColor: UIColor.black, bgColor: UIColor.white, bgColor2: UIColor(red: 0.6, green: 0.6, blue: 0.6)),
        PlayerColor(name: "Orange", textColor: UIColor.white, bgColor: UIColor.orange, bgColor2: UIColor(red: 0.6, green: 0.3, blue: 0)),
        PlayerColor(name: "Purple", textColor: UIColor.white, bgColor: UIColor.purple, bgColor2: UIColor(red: 0.9, green: 0, blue: 0.9)),
        PlayerColor(name: "Brown", textColor: UIColor.white, bgColor: UIColor.brown, bgColor2: UIColor(red: 0.9, green: 0.7, blue: 0.5)),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialTimeStepper.addTarget(self, action: #selector(self.initialTimeStepperValueChanged), for: .valueChanged)
        self.initialTimeStepper.maximumValue = 20 * 60
        self.initialTimeStepper.stepValue = 30
        self.initialTimeStepper.value = 180

        self.turnTimeStepper.addTarget(self, action: #selector(self.turnTimeStepperValueChanged), for: .valueChanged)
        self.turnTimeStepper.maximumValue = 3 * 60
        self.turnTimeStepper.stepValue = 5
        self.turnTimeStepper.value = 30
        
        self.playersStepper.value = 6
        self.playersStepper.minimumValue = 2
        self.playersStepper.maximumValue = 8
        
        self.playersStepperValueChanged(self.playersStepper)
    }
    
    @objc func initialTimeStepperValueChanged() {
        self.initialTimeLabel.text = TimeInterval(self.initialTimeStepper.value).toString(showMs: false)
    }

    @objc func turnTimeStepperValueChanged() {
        self.turnTimeLabel.text = TimeInterval(self.turnTimeStepper.value).toString(showMs: false)
    }

    @IBAction func playersStepperValueChanged(_ sender: Any) {
        let totalPlayers = Int(self.playersStepper.value)
        self.playersLabel.text =  "\(totalPlayers) players"

        for vc in self.colorSelectors {
            vc.removeFromSuperview()
        }
        self.colorSelectors = [ColorSelectorControl]()
        
        for i in 0..<totalPlayers {

            let colorSelector = ColorSelectorControl(availableColors: SetupViewController.availableColors, selectedColorIndex: i)
            self.view.addSubview(colorSelector)

            self.colorSelectors.append(colorSelector)

            let colorSelectorsViewReferent = i < 4 ? self.colorSelectorsView : self.colorSelectors2View
            if (i == 0 || i == 4) {
                colorSelector.autoPinEdge(.top, to: .top, of: colorSelectorsViewReferent!)
            } else {
                colorSelector.autoPinEdge(.top, to: .bottom, of: self.colorSelectors[i-1], withOffset: 10)
            }
            
            colorSelector.autoPinEdge(.left, to: .left, of: colorSelectorsViewReferent!, withOffset: 30)
            colorSelector.autoPinEdge(.right, to: .right, of: colorSelectorsViewReferent!, withOffset: -30)
            colorSelector.autoSetDimension(.height, toSize: 30)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timersVC = segue.destination as! TimersViewController
        timersVC.hidesBottomBarWhenPushed = true
        timersVC.initialTime = initialTimeStepper.value
        timersVC.turnTime = turnTimeStepper.value
        timersVC.totalPlayers = Int(playersStepper.value)
        
        timersVC.playerColors = self.colorSelectors.map({ (vc) -> PlayerColor in
            return SetupViewController.availableColors[vc.selectedColorIndex]
        })
    }
}
