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
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.name, forKey: "bggUser");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.bggUser = aDecoder.decodeObject(forKey: "bggUser") as? String
        super.init()
    }
    
    var name: String
    var bggUser: String?
    var preferredColor: String?
    
    init(name: String, bggUser: String?) {
        self.name = name
        self.bggUser = bggUser
    }
    
    static func all() -> [String: Player] {
        if let data = UserDefaults.standard.data(forKey: "players"),
            let players = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Player] {
            return players
        }
        return [:]
    }
    
    static func addOrUpdatePlayer(_ player: Player) {
        var allPlayers = all()
        allPlayers[player.name] = player
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