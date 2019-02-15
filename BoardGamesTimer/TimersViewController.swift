//
//  ClocksViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/15/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

protocol TimerPlayer {
    func isRunning() -> Bool
    func startTimer()
    func stopTimer()
}

struct PlayerViewFactory {
    static func createPlayerView(playerColor: PlayerColor, initialTime: TimeInterval, turnTime: TimeInterval) -> UIView {
        return InitialPlusTurnTimerPlayerView(playerColor: playerColor, initialTime: initialTime, turnTime: turnTime)
    }
}

class TimersViewController: UIViewController {
    
    var initialTime: TimeInterval?
    var turnTime: TimeInterval?
    var totalPlayers: Int?
    var playerViews = [UIView]()
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

            let v = PlayerViewFactory.createPlayerView(playerColor: playerColors![i], initialTime: self.initialTime!, turnTime: self.turnTime!)
            playerViews.append(v)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector (self.didTap(sender:)))
            v.addGestureRecognizer(gesture)
        }
        
        addPortraitConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addPortraitConstraints() {

        self.navigationController?.navigationBar.isHidden = false

        for i in 0..<totalPlayers! {
            
            let v = playerViews[i]
            v.removeFromSuperview()
            view.addSubview(v)
            let rows = totalPlayers! < 4 ? totalPlayers! : Int(ceil(Double(totalPlayers!) / 2))
            let columns = totalPlayers! < 4 ? 1 : 2
            
            let topConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint

            if (i == 0 || (i < 2 && columns > 1)) {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 65)
            }
            else {
                topConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: playerViews[i-columns], attribute: .bottom, multiplier: 1, constant: 0)
            }
            
            if (i % 2 == 0 || columns == 1) {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            } else {
                leftConstraint = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: playerViews[0], attribute: .trailing, multiplier: 1, constant: 0)
            }
            
            let widthConstraint = NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / CGFloat(columns), constant: 0)
            let heightConstraint = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1 / CGFloat(rows), constant: -65 / CGFloat(rows))
            
            NSLayoutConstraint.activate([topConstraint, leftConstraint, heightConstraint, widthConstraint])
        }
        
    }
    
    func addLandscapeConstraints() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        for i in 0..<totalPlayers! {
            
            let v = playerViews[i]
            v.removeFromSuperview()
            view.addSubview(v)
            let columns = totalPlayers! > 3 ? Int(ceil(Double(totalPlayers!) / 2)) : totalPlayers!
            let rows = totalPlayers! > 3 ? 2 : 1
            
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
            let heightConstraint = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1 / CGFloat(rows), constant: 0)

            NSLayoutConstraint.activate([topConstraint, leftConstraint, heightConstraint, widthConstraint])
        }
    }

    @objc func didTap(sender: UITapGestureRecognizer) {
        for v in playerViews {
            let vTimerPlayer = v as! TimerPlayer
            if (v == sender.view) {
                if (vTimerPlayer.isRunning()) {
                    vTimerPlayer.stopTimer()
                }
                else {
                    vTimerPlayer.startTimer()
                }
            }
            else {
                if (vTimerPlayer.isRunning()) {
                    vTimerPlayer.stopTimer()
                }
            }
            
        }
    }

    @objc func orientationChanged() {
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
