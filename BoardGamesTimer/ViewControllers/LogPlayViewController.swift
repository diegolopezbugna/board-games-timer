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
    
    // TODO: cambiar
    var timerPlayers: [TimerPlayer]? {
        didSet {
            
        }
    }
    var play: Play?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(PositionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.register(PositionHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: headerCellIdentifier)
//        self.tableView.isEditing = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? LogPlayPlayerDetailsViewController {
            vc.delegate = self
        }
    }
}

extension LogPlayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timerPlayers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PositionTableViewCell
        //        cell?.positionLabel.text = String(indexPath.row + 1)
        cell?.colorLabel.text = self.timerPlayers?[indexPath.row].colorName
        //        cell?.pointsLabel.text = "0"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerCellIdentifier) as? PositionHeaderTableViewCell
        return cell ?? UIView()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.timerPlayers?[sourceIndexPath.row]
        if let movedObject = movedObject {
            self.timerPlayers?.remove(at: sourceIndexPath.row)
            self.timerPlayers?.insert(movedObject, at: destinationIndexPath.row)
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
        var selectedTimerPlayer = self.timerPlayers?[indexPath.row]
        self.performSegue(withIdentifier: "logPlayPlayerDetailsSegue", sender: self)
//        let vc = LogPlayPlayerDetailsViewController()
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LogPlayViewController: LogPlayPlayerDetailsDelegate {
    func detailsDismissed(playerDetails: PlayerDetails?) {
        // TODO: update timerPlayers
        self.tableView.reloadData()
    }
}
