//
//  PlayTableViewCell.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 4/4/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class PlayTableViewCell: UITableViewCell {

    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var gameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var lengthLabel: UILabel!
    @IBOutlet private var playersLabel: UILabel!
    
    override func awakeFromNib() {
        self.dayLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.gameLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func setup(play: Play) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d"
        self.dayLabel.text = dateFormatter.string(from: play.date).camelcased()
        self.gameLabel.text = play.game.name
        self.locationLabel.text = play.location
        self.lengthLabel.text = "Length".localized +  ": " + (play.gameLength != nil ? TimeInterval(play.gameLength!).toString(showMs: false) : "-")
        self.playersLabel.text = self.playersText(playerDetails: play.playerDetails)
    }
    
    func playersText(playerDetails: [PlayPlayerDetails]?) -> String {
        guard let playerDetails = playerDetails else { return "Players".localized + ": -" }
        var nameScoreText = [String]()
        for pd in playerDetails.sorted(by: { (pd1, pd2) -> Bool in
            ((pd1.score ?? 0) + ((pd1.won ?? false) ? 10000 : 0)) >
                (pd2.score ?? 0) + ((pd2.won ?? false) ? 10000 : 0)
        }) {
            let name = pd.player?.name ?? pd.teamColor ?? ""
            let score = pd.score != nil ? " (\(String(pd.score!)))" : ""
            nameScoreText.append(name + score)
        }
        return "Players".localized + ": " + nameScoreText.joined(separator: ", ")
    }
    
}
