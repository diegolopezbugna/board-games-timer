//
//  LogPlayViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 10/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class LogPlayViewController: UIViewController {
    let cellIdentifier = "positionCell"
    let headerCellIdentifier = "headerPositionCell"

    @IBOutlet var gameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var play: Play?
    var playPlayerDetails: [PlayPlayerDetails]?
    var selectedPlayer: PlayPlayerDetails?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(PositionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.register(PositionHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: headerCellIdentifier)
//        self.tableView.isEditing = true
        
        self.gameTextField.addTarget(self, action: #selector(self.gameTextFieldEditingChanged), for: .editingChanged)
        
        self.commentsTextView.layer.cornerRadius = 5
        self.commentsTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.commentsTextView.layer.borderWidth = 0.5
        self.commentsTextView.clipsToBounds = true
        
        self.saveButton.target = self
        self.saveButton.action = #selector(self.saveTapped)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? LogPlayPlayerDetailsViewController {
            vc.delegate = self
            vc.playerDetails = self.selectedPlayer
        }
    }
    
    @objc func saveTapped() {
        // TODO: start date? length?
        let play = Play(date: Date(), gameLength: 90)
        play.location = locationTextField.text
        play.comments = commentsTextView.text
        play.playerDetails = self.playPlayerDetails
        Play.insertPlay(play)
    }
    
    @objc func gameTextFieldEditingChanged() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false
            , block: { (timer) in
                self.searchGame()
        })
    }
    
    private func searchGame() {
        guard let textField = self.gameTextField,
            let prefix = textField.text,
            prefix.count > 2 else {
                return
        }
        let c = GameConnector()
        let prefixUppercased = prefix.uppercased()
        c.searchGames(prefix: prefix) { (games) in
            for g in games {
                if g.name!.uppercased().starts(with: prefixUppercased) {
                    DispatchQueue.main.async {
                        textField.text = g.name
                        textField.selectedTextRange = textField.textRange(
                            from: textField.position(from: textField.beginningOfDocument, offset: prefix.count)!,
                            to: textField.endOfDocument)
                    }
                    break
                }
            }
        }
    }
}

extension LogPlayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playPlayerDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PositionTableViewCell
        if let d = self.playPlayerDetails?[indexPath.row] {
            //cell?.positionLabel.text = String(indexPath.row + 1)
            cell?.colorLabel.text = d.teamColor
            cell?.playerLabel.text = d.player?.name
            cell?.scoreLabel.text = d.score != nil ? String(d.score!) : ""
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerCellIdentifier) as? PositionHeaderTableViewCell
        return cell ?? UIView()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.playPlayerDetails?[sourceIndexPath.row]
        if let movedObject = movedObject {
            self.playPlayerDetails?.remove(at: sourceIndexPath.row)
            self.playPlayerDetails?.insert(movedObject, at: destinationIndexPath.row)
            self.tableView.reloadData()
        }
    }
}

extension LogPlayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlayer = self.playPlayerDetails?[indexPath.row]
        self.performSegue(withIdentifier: "logPlayPlayerDetailsSegue", sender: self)
    }
}

extension LogPlayViewController: LogPlayPlayerDetailsDelegate {
    func detailsDismissed(playerDetails: PlayPlayerDetails?) {
        self.tableView.reloadData()
    }
}