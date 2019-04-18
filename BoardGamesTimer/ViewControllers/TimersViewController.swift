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
    func showStartingPlayerMark()
    func hideStartingPlayerMark()
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
    var playerColors: [PlayerColor]?

    private var playerViews = [UIView]()
    private var gameStartDateTime: Date?
    private var gameLength: TimeInterval? {
        guard let gameStartDateTime = self.gameStartDateTime else { return nil }
        return Date().timeIntervalSince(gameStartDateTime)
    }
    private var isShowingStartingPlayer = false
    private var tapToSeeStartingPlayerView: UIView?

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

        self.gameStartDateTime = Date()
        
        for i in 0..<(self.totalPlayers!) {

            let v = PlayerViewFactory.createPlayerView(playerColor: playerColors![i], initialTime: self.initialTime!, turnTime: self.turnTime!)
            self.playerViews.append(v)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector (self.didTap(sender:)))
            v.addGestureRecognizer(gesture)
        }
        
        self.addPortraitConstraints()
        
        self.showTapToSeeStartingPlayerView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "logPlaySegue" {
            let alert = UIAlertController(title: "End Game?".localized, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { (action) in
                self.endGame()
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        for v in self.playerViews {
            let vTimerPlayer = v as! TimerPlayer
            if self.isShowingStartingPlayer {
                vTimerPlayer.hideStartingPlayerMark()
            }
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
    
    private func endGame() {
        for v in playerViews {
            let vTimerPlayer = v as! TimerPlayer
            if (vTimerPlayer.isRunning()) {
                vTimerPlayer.stopTimer()
            }
        }
        self.navigateToLogPlay()
    }
    
    private func navigateToLogPlay() {
        guard let navigationController = self.navigationController else { return }
        
        self.hidesBottomBarWhenPushed = false
        let playPlayerDetails = self.playerViews.map({ (v) -> PlayPlayerDetails in
            let timerPlayer = v as? TimerPlayer
            let d = PlayPlayerDetails()
            d.teamColor = timerPlayer?.colorName
            d.time = timerPlayer?.totalTime
            return d
        })
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LogPlayViewController") as! LogPlayViewController
        vc.playPlayerDetails = playPlayerDetails
        vc.gameStartDateTime = self.gameStartDateTime
        vc.gameLength = self.gameLength
        
        var vcs = navigationController.viewControllers
        vcs.removeLast()
        vcs.append(vc)
        navigationController.setViewControllers(vcs, animated: true)
    }
    
    @objc func orientationChanged() {
        if UIDevice.current.orientation.isLandscape {
            addLandscapeConstraints()
        }
        else if UIDevice.current.orientation == .portrait {
            addPortraitConstraints()
        }
        if let tapToSeeStartingPlayerView = self.tapToSeeStartingPlayerView {
            tapToSeeStartingPlayerView.removeFromSuperview()
            self.view.addSubview(tapToSeeStartingPlayerView)
            tapToSeeStartingPlayerView.autoPinEdgesToSuperviewEdges()
        }
    }

    private func addPortraitConstraints() {

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
    
    private func addLandscapeConstraints() {
        
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
    
    private func showTapToSeeStartingPlayerView() {
        let tapView = UIView(forAutoLayout: ())
        tapView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(tapView)
        tapView.autoPinEdgesToSuperviewEdges()
        let label = UILabel(forAutoLayout: ())
        tapView.addSubview(label)
        label.text = "Tap to randomize starting player!".localized
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.autoPinEdge(toSuperviewEdge: .left, withInset: 32)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: 32)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.textAlignment = .center
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.didTapTapToSeeStartingPlayerView(sender:)))
        tapView.addGestureRecognizer(gestureRecognizer)
        self.tapToSeeStartingPlayerView = tapView
    }
    
    @objc func didTapTapToSeeStartingPlayerView(sender: UITapGestureRecognizer) {
        self.showStartingPlayer()
        self.tapToSeeStartingPlayerView?.removeFromSuperview()
        self.tapToSeeStartingPlayerView = nil
    }
    
    private func showStartingPlayer() {
        let firstPlayer = Int.random(in: 0..<self.totalPlayers!)
        if let v = self.playerViews[firstPlayer] as? TimerPlayer {
            v.showStartingPlayerMark()
        }
        self.isShowingStartingPlayer = true
    }
}
