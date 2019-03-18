//
//  PlayersSetupViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 3/8/18.
//  Copyright © 2018 Diego. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    
    var players: [Player] = []
    
    @IBOutlet var playersTableView: UITableView!
    
    override func viewDidLoad() {
        self.players = Player.allSorted()
        playersTableView.dataSource = self
        playersTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddPlayerViewController {
            (segue.destination as! AddPlayerViewController).delegate = self
        }
    }
}

extension PlayersViewController: AddPlayerViewControllerDelegate {
    
    func adedOrUpdatedPlayer(_ player: Player) {
        self.players = Player.allSorted()
        playersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            Player.deletePlayer(self.players[indexPath.row])
            self.players = Player.allSorted()
            tableView.reloadData()
        }
        return [deleteAction]
    }
}

extension PlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        cell.textLabel?.text = self.players[indexPath.row].name
        return cell
    }

}

extension PlayersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = self.players[indexPath.row]
        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = board.instantiateViewController(withIdentifier: "AddPlayer") as! AddPlayerViewController
        vc.player = player
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
