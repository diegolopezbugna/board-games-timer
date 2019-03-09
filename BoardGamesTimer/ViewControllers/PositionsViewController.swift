//
//  PositionsViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 4/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class PositionsViewController: UITableViewController {
    let cellIdentifier = "positionCell"
    let headerCellIdentifier = "headerPositionCell"

    var timerPlayers: [TimerPlayer]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(PositionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.register(PositionHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: headerCellIdentifier)
        self.tableView.isEditing = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerPlayers?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PositionTableViewCell
//        cell?.positionLabel.text = String(indexPath.row + 1)
        cell?.colorLabel.text = self.timerPlayers?[indexPath.row].colorName
//        cell?.pointsLabel.text = "0"
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerCellIdentifier) as? PositionHeaderTableViewCell
        return cell ?? UIView()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.timerPlayers?[sourceIndexPath.row]
        if let movedObject = movedObject {
            self.timerPlayers?.remove(at: sourceIndexPath.row)
            self.timerPlayers?.insert(movedObject, at: destinationIndexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
