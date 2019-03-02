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

    @IBOutlet var initialTimeLabel: UILabel!
    @IBOutlet var initialTimeStepper: UIStepper!
    @IBOutlet var turnTimeLabel: UILabel!
    @IBOutlet var turnTimeStepper: UIStepper!
    
    @IBOutlet var playersLabel: UILabel!
    @IBOutlet var playersStepper: UIStepper!
    @IBOutlet var colorSelectorsView: UIView!
    @IBOutlet var colorSelectors2View: UIView!
    
    var colorSelectors = [ColorSelectorViewController]()

    let availableColors = [
        PlayerColor(name: "red", textColor: UIColor.white, bgColor: UIColor(red: 0.6, green: 0, blue: 0), bgColor2: UIColor(red: 1, green: 0, blue: 0)),
        PlayerColor(name: "green", textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0.5, blue: 0), bgColor2: UIColor(red: 0, green: 0.9, blue: 0)),
        PlayerColor(name: "blue", textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0, blue: 0.6), bgColor2: UIColor(red: 0.3, green: 0.3, blue: 1)),
        PlayerColor(name: "yellow", textColor: UIColor.black, bgColor: UIColor.yellow, bgColor2: UIColor(red: 0.6, green: 0.6, blue: 0)),
        PlayerColor(name: "black", textColor: UIColor.white, bgColor: UIColor.black, bgColor2: UIColor(red: 0.4, green: 0.4, blue: 0.4)),
        PlayerColor(name: "white", textColor: UIColor.black, bgColor: UIColor.white, bgColor2: UIColor(red: 0.6, green: 0.6, blue: 0.6)),
        PlayerColor(name: "orange", textColor: UIColor.white, bgColor: UIColor.orange, bgColor2: UIColor(red: 0.6, green: 0.3, blue: 0)),
        PlayerColor(name: "purple", textColor: UIColor.white, bgColor: UIColor.purple, bgColor2: UIColor(red: 0.9, green: 0, blue: 0.9)),
        PlayerColor(name: "brown", textColor: UIColor.white, bgColor: UIColor.brown, bgColor2: UIColor(red: 0.9, green: 0.7, blue: 0.5)),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initialTimeStepper.addTarget(self, action: #selector(self.initialTimeStepperValueChanged), for: .valueChanged)
        initialTimeStepper.maximumValue = 20 * 60
        initialTimeStepper.stepValue = 30
        initialTimeStepper.value = 180

        turnTimeStepper.addTarget(self, action: #selector(self.turnTimeStepperValueChanged), for: .valueChanged)
        turnTimeStepper.maximumValue = 3 * 60
        turnTimeStepper.stepValue = 5
        turnTimeStepper.value = 30
        
        playersStepper.value = 6
        playersStepper.minimumValue = 2
        playersStepper.maximumValue = 8
        
        playersStepperValueChanged(playersStepper)
    }
    
    @objc func initialTimeStepperValueChanged() {
        initialTimeLabel.text = TimeInterval(initialTimeStepper.value).toString(showMs: false)
    }

    @objc func turnTimeStepperValueChanged() {
        turnTimeLabel.text = TimeInterval(turnTimeStepper.value).toString(showMs: false)
    }

    @IBAction func playersStepperValueChanged(_ sender: Any) {
        let totalPlayers = Int(playersStepper.value)
        playersLabel.text =  "\(totalPlayers) players"

        for vc in colorSelectors {
            removeViewController(vc)
        }
        colorSelectors = [ColorSelectorViewController]()
        
        for i in 0..<totalPlayers {

            let colorSelectorVC = ColorSelectorViewController(availableColors: availableColors, selectedColorIndex: i)
            self.addViewController(colorSelectorVC)
            let colorSelector = colorSelectorVC.view!
            colorSelector.translatesAutoresizingMaskIntoConstraints = false

            colorSelectors.append(colorSelectorVC)

            let colorSelectorsViewReferent = i < 4 ? colorSelectorsView : colorSelectors2View
            var top: NSLayoutConstraint
            if (i == 0 || i == 4) {
                top = NSLayoutConstraint(item: colorSelector, attribute: .top, relatedBy: .equal, toItem: colorSelectorsViewReferent, attribute: .top, multiplier: 1, constant: 0)
            }
            else {
                top = NSLayoutConstraint(item: colorSelector, attribute: .top, relatedBy: .equal, toItem: colorSelectors[i-1].view, attribute: .bottom, multiplier: 1, constant: 10)
            }
            let left = NSLayoutConstraint(item: colorSelector, attribute: .left, relatedBy: .equal, toItem: colorSelectorsViewReferent, attribute: .left, multiplier: 1, constant: 30)
            let right = NSLayoutConstraint(item: colorSelector, attribute: .right, relatedBy: .equal, toItem: colorSelectorsViewReferent, attribute: .right, multiplier: 1, constant: -30)
            let height = NSLayoutConstraint(item: colorSelector, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            
            NSLayoutConstraint.activate([top, height, left, right])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timersVC = segue.destination as! TimersViewController
        timersVC.hidesBottomBarWhenPushed = true
        timersVC.initialTime = initialTimeStepper.value
        timersVC.turnTime = turnTimeStepper.value
        timersVC.totalPlayers = Int(playersStepper.value)
        
        timersVC.playerColors = colorSelectors.map({ (vc) -> PlayerColor in
            return availableColors[vc.selectedColorIndex]
        })
    }
    
    func addViewController(_ vc: UIViewController) {
        addChildViewController(vc)
        view.addSubview(vc.view)
        // constraints
        vc.didMove(toParentViewController: self)
    }
    
    func removeViewController(_ vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
}
