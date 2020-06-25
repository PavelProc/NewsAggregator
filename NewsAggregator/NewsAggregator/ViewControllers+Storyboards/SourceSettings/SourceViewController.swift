//
//  SourceViewController.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 24.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController {
    
    @IBOutlet weak var sourceTableView: UITableView! {
        didSet {
            self.sourceTableView.register(UINib.init(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
            sourceTableView.delegate = self
            sourceTableView.dataSource = self
        }
    }
    
    var sites: [Site]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceTableView.tableFooterView = UIView()
    }
}

//MARK: - UITableViewDelegate
extension SourceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        let site = sites[indexPath.row]
        if site.isActive {
            sites[indexPath.row].isActive = false
            site.isActive = false
            cell?.accessoryType = .none
        } else {
            sites[indexPath.row].isActive = true
            site.isActive = true
            cell?.accessoryType = .checkmark
        }
        
        CoreDataManager.shared.editURL(site: site)
    }
}

//MARK: - UITableViewDataSource
extension SourceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as? SettingsTableViewCell else {return UITableViewCell()}
        cell.nameCellLabel.text = sites[indexPath.row].url
        if sites[indexPath.row].isActive {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

