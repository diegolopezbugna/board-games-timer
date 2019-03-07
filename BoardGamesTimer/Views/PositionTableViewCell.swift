//
//  PositionTableViewCell.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 4/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    
    var positionLabel: UILabel!
    var colorLabel: UILabel!
    var pickerView: UIPickerView!
    let players = Player.allSorted()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .horizontal
        stackView.distribution = .fill
        self.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
        
        self.positionLabel = self.createLabel()
        stackView.addArrangedSubview(self.positionLabel)
        self.positionLabel.autoSetDimension(.width, toSize: 40)
        self.colorLabel = self.createLabel()
        stackView.addArrangedSubview(self.colorLabel)
        self.colorLabel.autoSetDimension(.width, toSize: 80)

        self.pickerView = UIPickerView(forAutoLayout: ())
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        stackView.addArrangedSubview(self.pickerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel() -> UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }

}

extension PositionTableViewCell: UIPickerViewDelegate {
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

extension PositionTableViewCell: UIPickerViewDataSource {
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


