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
        self.createPositionLabel()
        self.createColorLabel()
        self.createPicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPositionLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let centerY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16)
        let width = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        self.addConstraints([left, centerY, width])
        self.positionLabel = label
    }
    
    func createColorLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let centerY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self.positionLabel, attribute: .trailing, multiplier: 1, constant: 16)
        let width = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        self.addConstraints([left, centerY, width])
        self.colorLabel = label
    }
    
    func createPicker() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(picker)
        let left = NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: self.colorLabel!, attribute: .trailing, multiplier: 1, constant: 16)
        let right = NSLayoutConstraint(item: picker, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -32)
        let top = NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: self.positionLabel!, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: self.positionLabel!, attribute: .bottom, multiplier: 1, constant: 0)
        let heigth = NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        self.addConstraints([left, right, top, bottom, heigth])
        self.pickerView = picker
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


