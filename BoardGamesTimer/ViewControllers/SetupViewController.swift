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
    
    private var colorSelectors = [ColorSelectorControl]()
    private var colorSelectorBottomConstraint: NSLayoutConstraint?

    static let availableColors = [
        PlayerColor(name: "Red".localized, textColor: UIColor.white, bgColor: UIColor(red: 0.6, green: 0, blue: 0), bgColor2: UIColor(red: 1, green: 0, blue: 0)),
        PlayerColor(name: "Green".localized, textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0.5, blue: 0), bgColor2: UIColor(red: 0, green: 0.9, blue: 0)),
        PlayerColor(name: "Blue".localized, textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0, blue: 0.6), bgColor2: UIColor(red: 0.3, green: 0.3, blue: 1)),
        PlayerColor(name: "Yellow".localized, textColor: UIColor.black, bgColor: UIColor.yellow, bgColor2: UIColor(red: 0.6, green: 0.6, blue: 0)),
        PlayerColor(name: "Black".localized, textColor: UIColor.white, bgColor: UIColor.black, bgColor2: UIColor(red: 0.4, green: 0.4, blue: 0.4)),
        PlayerColor(name: "White".localized, textColor: UIColor.black, bgColor: UIColor.white, bgColor2: UIColor(red: 0.6, green: 0.6, blue: 0.6)),
        PlayerColor(name: "Orange".localized, textColor: UIColor.white, bgColor: UIColor.orange, bgColor2: UIColor(red: 0.6, green: 0.3, blue: 0)),
        PlayerColor(name: "Purple".localized, textColor: UIColor.white, bgColor: UIColor.purple, bgColor2: UIColor(red: 0.9, green: 0, blue: 0.9)),
        PlayerColor(name: "Brown".localized, textColor: UIColor.white, bgColor: UIColor.brown, bgColor2: UIColor(red: 0.9, green: 0.7, blue: 0.5)),
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
        
        self.playersStepper.value = 4
        self.playersStepper.minimumValue = 2
        self.playersStepper.maximumValue = 8
        for _ in 1...Int(self.playersStepper.value) {
            self.appendColorSelector()
        }

        self.playersStepperValueChanged(self.playersStepper)
    }
    
    @objc func initialTimeStepperValueChanged() {
        self.initialTimeLabel.text = TimeInterval(self.initialTimeStepper.value).toString(showMs: false)
    }

    @objc func turnTimeStepperValueChanged() {
        self.turnTimeLabel.text = TimeInterval(self.turnTimeStepper.value).toString(showMs: false)
    }

    @IBAction func playersStepperValueChanged(_ sender: Any) {
        let newTotalPlayers = Int(self.playersStepper.value)

        if newTotalPlayers < self.colorSelectors.count {
            self.removeLastColorSelector()
        } else if newTotalPlayers > self.colorSelectors.count {
            self.appendColorSelector()
        }
        
        self.playersLabel.text =  "\(self.colorSelectors.count) " + "players".localized
    }
    
    private func appendColorSelector() {
        let index = self.colorSelectors.count
        let colorSelector = ColorSelectorControl(availableColors: SetupViewController.availableColors, selectedColorIndex: index)
        self.colorSelectors.append(colorSelector)
        self.colorSelectorsView.addSubview(colorSelector)
        
        if index == 0 {
            colorSelector.autoPinEdge(toSuperviewEdge: .top)
        } else {
            colorSelector.autoPinEdge(.top, to: .bottom, of: self.colorSelectors[index - 1], withOffset: 10)
        }
        colorSelector.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
        colorSelector.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
        colorSelector.autoSetDimension(.height, toSize: 30)
        colorSelector.alpha = 0
        self.updateConstraintForScrollView()

        UIView.animate(withDuration: 0.2) {
            colorSelector.alpha = 1
        }
    }
    
    private func removeLastColorSelector() {
        let lastColorSelector = self.colorSelectors[self.colorSelectors.count - 1]
        self.colorSelectors.removeLast()
        self.updateConstraintForScrollView()

        UIView.animate(withDuration: 0.2, animations: {
            lastColorSelector.alpha = 0
        }) { (_) in
            lastColorSelector.removeFromSuperview()
        }
    }
    
    private func updateConstraintForScrollView() {
        self.colorSelectorBottomConstraint?.autoRemove()
        self.colorSelectorBottomConstraint = self.colorSelectorsView.autoPinEdge(.bottom, to: .bottom, of: self.colorSelectors[self.colorSelectors.count - 1], withOffset: 16)
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
