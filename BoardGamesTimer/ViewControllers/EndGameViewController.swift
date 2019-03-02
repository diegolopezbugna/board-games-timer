//
//  EndGameViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 2/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    var timerPlayers: [TimerPlayer]?
    let players = Player.allSorted()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let timerPlayers = timerPlayers {
            for t in timerPlayers {
                let v = EndGamePlayerView(timerPlayer: t)
                v.pickerView?.dataSource = self
                v.pickerView?.delegate = self
                stackView.addArrangedSubview(v)
            }
        }
    }
}

extension EndGameViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.players.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25
    }
}

extension EndGameViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.players[row].name
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel!.font = UIFont.systemFont(ofSize: 17)
            pickerLabel!.textAlignment  = .center
        }
        pickerLabel!.text = row > 0 ? self.players[row - 1].name : ""
        return pickerLabel!
    }
}
