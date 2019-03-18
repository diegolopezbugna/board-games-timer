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

    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var play: Play?
    var playPlayerDetails: [PlayPlayerDetails]?
    var selectedPlayer: PlayPlayerDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(PositionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.register(PositionHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: headerCellIdentifier)
//        self.tableView.isEditing = true
        
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
