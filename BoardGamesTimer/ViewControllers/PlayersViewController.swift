//
//  PlayersSetupViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 3/8/18.
//  Copyright © 2018 Diego. All rights reserved.
//

import UIKit

class Player: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id");
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.bggUser, forKey: "bggUser");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! UUID
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.bggUser = aDecoder.decodeObject(forKey: "bggUser") as? String
        super.init()
    }
    
    var id: UUID
    var name: String
    var bggUser: String?
    var preferredColor: String?
    
    init(id: UUID, name: String, bggUser: String?) {
        self.id = id
        self.name = name
        self.bggUser = bggUser
    }
    
    static func all() -> [UUID: Player] {
        if let data = UserDefaults.standard.data(forKey: "players"),
            let players = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UUID: Player] {
            return players
        }
        return [:]
    }
    
    static func addOrUpdatePlayer(_ player: Player) {
        var allPlayers = all()
        allPlayers[player.id] = player
        let data = NSKeyedArchiver.archivedData(withRootObject: allPlayers)
        UserDefaults.standard.set(data, forKey: "players")
    }
    
    static func deletePlayer(_ player: Player) {
        var allPlayers = all()
        allPlayers.removeValue(forKey: player.id)
        let data = NSKeyedArchiver.archivedData(withRootObject: allPlayers)
        UserDefaults.standard.set(data, forKey: "players")
    }
}

class PlayersViewController: UIViewController {
    
    var players: [Player] = []
    
    @IBOutlet var playersTableView: UITableView!
    
    override func viewDidLoad() {
        self.players = Array(Player.all().values)
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
        self.players = Array(Player.all().values)
        playersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            Player.deletePlayer(self.players[indexPath.row])
            self.players = Array(Player.all().values)
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
