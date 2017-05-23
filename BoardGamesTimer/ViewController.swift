//
//  ViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/15/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

struct PlayerColor {
    var textColor: UIColor
    var bgColor: UIColor
    var bgColor2: UIColor
}

class ViewController: UIViewController {

    @IBOutlet var playersLabel: UILabel!
    @IBOutlet var playersStepper: UIStepper!
    @IBOutlet var colorSelectorsView: UIView!
    
    var colorSelectors = [ColorSelectorViewController]()

    let availableColors = [
                        PlayerColor(textColor: UIColor.white, bgColor: UIColor(red: 0.6, green: 0, blue: 0), bgColor2: UIColor(red: 0.8, green: 0, blue: 0)),
                        PlayerColor(textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0.5, blue: 0), bgColor2: UIColor(red: 0, green: 0.7, blue: 0)),
                        PlayerColor(textColor: UIColor.white, bgColor: UIColor(red: 0, green: 0, blue: 0.7), bgColor2: UIColor(red: 0, green: 0, blue: 1)),
                        PlayerColor(textColor: UIColor.black, bgColor: UIColor.yellow, bgColor2: UIColor(red: 0.75, green: 0.75, blue: 0)),
                        PlayerColor(textColor: UIColor.white, bgColor: UIColor.black, bgColor2: UIColor(red: 0.25, green: 0.25, blue: 0.25)),
                        PlayerColor(textColor: UIColor.black, bgColor: UIColor.white, bgColor2: UIColor(red: 0.7, green: 0.7, blue: 0.7)),
                        PlayerColor(textColor: UIColor.white, bgColor: UIColor(red: 0.85, green: 0.4, blue: 0), bgColor2: UIColor.orange),
                        PlayerColor(textColor: UIColor.white, bgColor: UIColor.purple, bgColor2: UIColor(red: 0.7, green: 0, blue: 0.7)),
                        PlayerColor(textColor: UIColor.white, bgColor: UIColor.brown, bgColor2: UIColor(red: 0.75, green: 0.55, blue: 0.35)),
                        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playersStepper.value = 6
        playersStepper.minimumValue = 2
        playersStepper.maximumValue = 8
        
        playersStepperValueChanged(playersStepper)
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

            var top: NSLayoutConstraint
            if (i == 0) {
                top = NSLayoutConstraint(item: colorSelector, attribute: .top, relatedBy: .equal, toItem: colorSelectorsView, attribute: .top, multiplier: 1, constant: 0)
            }
            else {
                top = NSLayoutConstraint(item: colorSelector, attribute: .top, relatedBy: .equal, toItem: colorSelectors[i-1].view, attribute: .bottom, multiplier: 1, constant: 0)
            }
            let left = NSLayoutConstraint(item: colorSelector, attribute: .left, relatedBy: .equal, toItem: colorSelectorsView, attribute: .left, multiplier: 1, constant: 30)
            let right = NSLayoutConstraint(item: colorSelector, attribute: .right, relatedBy: .equal, toItem: colorSelectorsView, attribute: .right, multiplier: 1, constant: -30)
            let height = NSLayoutConstraint(item: colorSelector, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            
            NSLayoutConstraint.activate([top, height, left, right])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timersVC = segue.destination as! TimersViewController
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
