//
//  PlayersSetupViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 3/8/18.
//  Copyright © 2018 Diego. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    
    @IBOutlet private var playersTableView: UITableView!
    
    private var players: [Player] = []
    
    var getPlayersUseCase: GetPlayersUseCaseProtocol
    let playersProvider: PlayersProviderProtocol = PlayersProvider()
    
    required init?(coder aDecoder: NSCoder) {
        self.getPlayersUseCase = GetPlayersUseCase(playersProvider: playersProvider)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.playersTableView.dataSource = self
        self.playersTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: loading
        getPlayersUseCase.completionSuccess = { players in
            self.players = players
            // TODO: end loading
            self.playersTableView.reloadData()
        }
        getPlayersUseCase.execute()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddPlayerViewController {
            (segue.destination as! AddPlayerViewController).delegate = self
        }
    }
    
    private func reloadPlayers() {
        getPlayersUseCase.completionSuccess = { players in
            self.players = players
            self.playersTableView.reloadData()
        }
        getPlayersUseCase.execute()
    }
}

extension PlayersViewController: AddPlayerViewControllerDelegate {
    
    func adedOrUpdatedPlayer(_ player: Player) {
        self.reloadPlayers()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized) { (action, indexPath) in
            self.playersProvider.deletePlayer(self.players[indexPath.row])
            self.reloadPlayers()
        }
        return [deleteAction]
    }
}

extension PlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
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
