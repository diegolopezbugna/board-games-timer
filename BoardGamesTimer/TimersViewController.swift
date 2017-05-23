//
//  ClocksViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/15/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class TimersViewController: UIViewController {
    
    var totalPlayers: Int?
    var playerViews = [PlayerView]()
    var playerColors: [PlayerColor]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector (orientationChanged), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<totalPlayers! {

            let v = PlayerView(playerColor: playerColors![i])
            playerViews.append(v)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector (self.didTap(sender:)))
            v.addGestureRecognizer(gesture)
        }
        
        addPortraitConstraints()
    }
    
    func addPortraitConstraints() {
        
        for i in 0..<totalPlayers! {
            
            let v = playerViews[i]
            v.removeFromSuperview()
            view.addSubview(v)
            let rows = Int(ceil(Double(totalPlayers!) / 2))
            
            let topConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint

            if (i < 2) {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20)
            }
            else {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: playerViews[i-2], attribute: .bottom, multiplier: 1, constant: 0)
            }
            
            if (i % 2 == 0) {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            } else {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: playerViews[0], attribute: .trailing, multiplier: 1, constant: 0)
            }
            
            let widthConstraint = NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/2, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1 / CGFloat(rows), constant: -20 / CGFloat(rows))
            
            NSLayoutConstraint.activate([topConstraint, leftConstraint, heightConstraint, widthConstraint])
        }
        
    }
    
    func addLandscapeConstraints() {
        
        for i in 0..<totalPlayers! {
            
            let v = playerViews[i]
            v.removeFromSuperview()
            view.addSubview(v)
            let columns = Int(ceil(Double(totalPlayers!) / 2))
            
            let topConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint
            
            if (i < columns) {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            } else {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: playerViews[0], attribute: .bottom, multiplier: 1, constant: 0)
            }
            
            if (i % columns == 0) {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            } else {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: playerViews[i-1], attribute: .trailing, multiplier: 1, constant: 0)
            }
            
            let widthConstraint = NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / CGFloat(columns), constant: 0)
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

    func orientationChanged() {
        if UIDevice.current.orientation.isLandscape {
            addLandscapeConstraints()
        }
        else if UIDevice.current.orientation == .portrait {
            addPortraitConstraints()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
