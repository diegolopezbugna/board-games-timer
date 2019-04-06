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
        return groups.map({ MonthSection(month: $0.key, plays: $0.value.sorted(by: { (p1, p2) -> Bool in
            p1.date < p2.date
        })) }).sorted().reversed()
    }
}

class PlaysViewController: UIViewController {
    let cellIdentifier = "playCell"
    let sectionHeaderIdentifier = "monthPlaySectionHeader"

    @IBOutlet private var tableView: UITableView!
    private var loadingView: UIView?
    private var activityIndicatorView: UIActivityIndicatorView? // TODO: move inside a control with the loadingView

    private var sections = [MonthSection]()
    private var selectedPlay: Play?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.register(PlaySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: self.sectionHeaderIdentifier)

        let playNib = UINib(nibName: "PlayTableViewCell", bundle: nil)
        self.tableView.register(playNib, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPlays()
    }
    
    private func getPlays() {
        let offlinePlays = Play.all()
        if let bggUsername = UserDefaults.standard.value(forKey: UserDefaults.Keys.bggUsername.rawValue) as? String,
            bggUsername.count > 0 {
            self.showLoading()
            let connector = PlaysConnector()
            connector.getPlays(username: bggUsername) { (plays) in
                if let onlinePlays = plays {
                    var allPlays = offlinePlays
                    allPlays.append(contentsOf: onlinePlays)
                    self.sections = MonthSection.group(plays: allPlays)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.hideLoading()
                    }
                }
            }
        } else {
            self.sections = MonthSection.group(plays: offlinePlays)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? LogPlayViewController {
            vc.play = self.selectedPlay
        }
    }
    
    private func showLoading() {
        if self.loadingView == nil {
            let loadingView = UIView(forAutoLayout: ())
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            self.view.addSubview(loadingView)
            loadingView.autoPinEdgesToSuperviewEdges()
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            loadingView.addSubview(activityIndicatorView)
            activityIndicatorView.autoCenterInSuperview()
            self.loadingView = loadingView
            self.activityIndicatorView = activityIndicatorView
        }
        self.activityIndicatorView?.startAnimating()
        self.loadingView?.isHidden = false
    }
    
    private func hideLoading() {
        self.activityIndicatorView?.stopAnimating()
        self.loadingView?.isHidden = true
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
        let play = self.sections[indexPath.section].plays[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! PlayTableViewCell
        cell.setup(play: play)
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlay = self.sections[indexPath.section].plays[indexPath.row]
        self.performSegue(withIdentifier: "playSegue", sender: self)
    }
}
