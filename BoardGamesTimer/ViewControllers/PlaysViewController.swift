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
        return groups.map({ MonthSection(month: $0.key, plays: $0.value) }).sorted().reversed()
    }
}

class PlaysViewController: UIViewController {
    let cellIdentifier = "playCell"
    let sectionHeaderIdentifier = "monthPlaySectionHeader"

    @IBOutlet var tableView: UITableView!
    
    var sections = [MonthSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.register(PlaySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: self.sectionHeaderIdentifier)
        self.tableView.register(PlayTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPlays()
    }
    
    private func getPlays() {
        guard let bggUsername = UserDefaults.standard.value(forKey: UserDefaults.Keys.bggUsername.rawValue) as? String,
            bggUsername.count > 0 else {
                self.tabBarController?.selectedIndex = 3  // TODO: remove hardcoded
            return
        }
        
        let connector = PlaysConnector()
        connector.getPlays(username: bggUsername) { (plays) in
            if let onlinePlays = plays {
                var allPlays = Play.all()
                allPlays.append(contentsOf: onlinePlays)
                self.sections = MonthSection.group(plays: allPlays)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension PlaysViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].plays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! PlayTableViewCell

        let date = self.sections[indexPath.section].plays[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d"
        cell.day.text = dateFormatter.string(from: date)
        
        cell.gameLabel.text = self.sections[indexPath.section].plays[indexPath.row].game.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.sectionHeaderIdentifier) as! PlaySectionHeaderView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let title = dateFormatter.string(from: self.sections[section].month)
        let colors = SetupViewController.availableColors.count
        let textColor = SetupViewController.availableColors[section % colors].textColor
        let backgroundColor = SetupViewController.availableColors[section % colors].bgColor
        view.config(text: title, textColor: textColor, backgroundColor: backgroundColor)
        return view
    }
}

extension PlaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
