//
//  PlaysViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 18/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

struct MonthSection: Comparable {
    var month : Date
    var plays: [Play]

    static func < (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month < rhs.month
    }
    static func == (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month == rhs.month
    }
    
    static func group(plays: [Play]) -> [MonthSection] {
        let groups = Dictionary(grouping: plays) { (play) -> Date in
            return play.date.firstDayOfMonth()
        }
        return groups.map({ MonthSection(month: $0.key, plays: $0.value) }).sorted()
    }
}

class PlaysViewController: UIViewController {
    let cellIdentifier = "playCell"

    @IBOutlet var tableView: UITableView!
    
    var sections = [MonthSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(PlayTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.sections = MonthSection.group(plays: Play.allTest())
    }
}

extension PlaysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].plays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! PlayTableViewCell
        cell.gameLabel.text = self.sections[indexPath.section].plays[indexPath.row].location
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
}

extension PlaysViewController: UITableViewDelegate {
}
