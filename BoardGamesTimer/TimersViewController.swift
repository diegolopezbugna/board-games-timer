//
//  ClocksViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/15/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class TimersViewController: UIViewController {
    
    var jugadores: Int?
    var playerViews = [PlayerView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let red = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        let red2 = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        let green = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
        let green2 = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
        let blue = UIColor(red: 0, green: 0, blue: 0.7, alpha: 1)
        let blue2 = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        let yellow2 = UIColor(red: 0.75, green: 0.75, blue: 0, alpha: 1)
        let black2 = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
        let white2 = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        let colors = [red, green, blue, UIColor.yellow, UIColor.black, UIColor.white]
        let animationColors = [red2, green2, blue2, yellow2, black2, white2]
        let fontColors = [UIColor.white, UIColor.white, UIColor.white, UIColor.black, UIColor.white, UIColor.black]
        
        for i in 0..<jugadores! {

            let v = PlayerView(color: colors[i], animationColor: animationColors[i], fontColor: fontColors[i])
            playerViews.append(v)
            view.addSubview(v)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector (self.didTap(sender:)))
            v.addGestureRecognizer(gesture)

            let topConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint

            if (i < 3) {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            } else {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: playerViews[0], attribute: .bottom, multiplier: 1, constant: 0)
            }
            
            if (i % 3 == 0) {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            } else if (i % 3 == 1) {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: playerViews[0], attribute: .trailing, multiplier: 1, constant: 0)
            } else {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: playerViews[1], attribute: .trailing, multiplier: 1, constant: 0)
            }
            
            let widthConstraint = NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/3, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/2, constant: 0)

            NSLayoutConstraint.activate([topConstraint, leftConstraint, heightConstraint, widthConstraint])
        }
    }

    func didTap(sender: UITapGestureRecognizer) {
        let tappedView = sender.view as! PlayerView
        
        for v in playerViews {
            
            if (v == tappedView) {
                if (v.isRunning()) {
                    v.stopTimer()
                }
                else {
                    v.startTimer()
                }
            }
            else {
                if (v.isRunning()) {
                    v.stopTimer()
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
