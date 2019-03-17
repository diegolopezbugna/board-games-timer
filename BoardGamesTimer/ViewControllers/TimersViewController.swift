//
//  ClocksViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/15/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

protocol TimerPlayer {
    var colorName: String { get }
    var totalTime: TimeInterval { get }
    func isRunning() -> Bool
    func startTimer()
    func stopTimer()
    func showTotal()
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
    var hasFinished = false

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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "logPlaySegue" {
            if self.hasFinished {
                return true
            }
            let alert = UIAlertController(title: "End Game", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                self.endGame()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logPlaySegue" {
            if let vc = segue.destination as? LogPlayViewController {
                vc.timerPlayers = self.playerViews.map({ $0 as! TimerPlayer })
            }
        }
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        guard !self.hasFinished else { return }
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
    
    func endGame() {
        if !self.hasFinished {
            for v in playerViews {
                let vTimerPlayer = v as! TimerPlayer
                if (vTimerPlayer.isRunning()) {
                    vTimerPlayer.stopTimer()
                }
                vTimerPlayer.showTotal()
            }
            self.hasFinished = true
            self.navigationItem.rightBarButtonItem?.title = "Positions"
        } else {
            self.performSegue(withIdentifier: "logPlaySegue", sender: self)
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

    func addPortraitConstraints() {

        self.navigationController?.navigationBar.isHidden = false

        for i in 0..<totalPlayers! {
            
            let v = playerViews[i]
            v.removeFromSuperview()
            view.addSubview(v)
            let rows = totalPlayers! < 4 ? totalPlayers! : Int(ceil(Double(totalPlayers!) / 2))
            let columns = totalPlayers! < 4 ? 1 : 2
            
            if (i == 0 || (i < 2 && columns > 1)) {
                v.autoPinEdge(.top, to: .top, of: view, withOffset: 65)
            } else {
                v.autoPinEdge(.top, to: .bottom, of: playerViews[i-columns])
            }
            
            if (i % 2 == 0 || columns == 1) {
                v.autoPinEdge(.left, to: .left, of: view)
            } else {
                v.autoPinEdge(.left, to: .right, of: playerViews[0])
            }
            
            v.autoMatch(.width, to: .width, of: view, withMultiplier: 1 / CGFloat(columns))
            
            let heightConstraint = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1 / CGFloat(rows), constant: -65 / CGFloat(rows)) // no pureLayout for both multiplier and offset
            NSLayoutConstraint.activate([heightConstraint])
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
            
            if (i < columns) {
                v.autoPinEdge(.top, to: .top, of: view)
            } else {
                v.autoPinEdge(.top, to: .bottom, of: playerViews[0])
            }
            
            if (i % columns == 0) {
                v.autoPinEdge(.left, to: .left, of: view)
            } else {
                v.autoPinEdge(.left, to: .right, of: playerViews[i-1])
            }
            
            v.autoMatch(.width, to: .width, of: view, withMultiplier: 1 / CGFloat(columns))
            v.autoMatch(.height, to: .height, of: view, withMultiplier: 1 / CGFloat(rows))
        }
    }
}
