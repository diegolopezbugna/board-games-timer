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
    var plays: [LoggedPlay]

    static func < (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month < rhs.month
    }
    static func == (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month == rhs.month
    }
    
    static func group(plays: [LoggedPlay]) -> [MonthSection] {
        let groups = Dictionary(grouping: plays) { (play) -> Date in
            return play.date.firstDayOfMonth()
        }
        return groups.map({ MonthSection(month: $0.key, plays: $0.value.sorted(by: { (p1, p2) -> Bool in
            p1.date > p2.date
        })) }).sorted().reversed()
    }
}

class PlaysViewController: UIViewController {
    let cellIdentifier = "playCell"
    let sectionHeaderIdentifier = "monthPlaySectionHeader"

    @IBOutlet private var tableView: UITableView!
    private var loadingView: UIView?
    private var activityIndicatorView: UIActivityIndicatorView? // TODO: move inside a control with the loadingView

    private var getLoggedPlaysUseCase: GetLoggedPlaysUseCaseProtocol
    
    private var sections = [MonthSection]()
    private var selectedPlay: LoggedPlay?
    
    required init?(coder aDecoder: NSCoder) {
        getLoggedPlaysUseCase = GetLoggedPlaysUseCase(
            offlineLoggedPlaysProvider: OfflineLoggedPlaysProvider(),
            bggLoggedPlaysProvider: BggLoggedPlaysProvider(),
            getBggUsernameUseCase: GetBggUsernameUseCase(bggUsernameProvider: BggUsernameProvider()))
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(PlaySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: sectionHeaderIdentifier)

        let playNib = UINib(nibName: "PlayTableViewCell", bundle: nil)
        tableView.register(playNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlays()
    }
    
    private func getPlays() {
        showLoading()
        getLoggedPlaysUseCase.completionSuccess = { plays in
            self.sections = MonthSection.group(plays: plays)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideLoading()
            }
        }
        getLoggedPlaysUseCase.execute()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? LogPlayViewController {
            vc.play = selectedPlay
        }
    }
    
    private func showLoading() {
        if loadingView == nil {
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
        activityIndicatorView?.startAnimating()
        loadingView?.isHidden = false
    }
    
    private func hideLoading() {
        activityIndicatorView?.stopAnimating()
        loadingView?.isHidden = true
    }
}

extension PlaysViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].plays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let play = sections[indexPath.section].plays[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! PlayTableViewCell
        cell.setup(play: play)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.sectionHeaderIdentifier) as! PlaySectionHeaderView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let title = dateFormatter.string(from: self.sections[section].month).camelcased()
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
        selectedPlay = sections[indexPath.section].plays[indexPath.row]
        performSegue(withIdentifier: "playSegue", sender: self)
    }
}
