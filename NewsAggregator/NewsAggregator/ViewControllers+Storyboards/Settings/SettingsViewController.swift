//
//  SettingsViewController.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 22.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var timePickerView: UIPickerView! {
        didSet {
            timePickerView.delegate = self
            timePickerView.dataSource = self
        }
    }
    @IBOutlet weak var settingTableView: UITableView! {
        didSet {
            self.settingTableView.register(UINib.init(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
            settingTableView.delegate = self
            settingTableView.dataSource = self
        }
    }
    
    //MARK: - Propertyes
    let settingsDataManager = SettingsDataManager()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.tableFooterView = UIView()
    }
    
    @IBAction func DoneAction(_ sender: UIBarButtonItem) {
        self.dismiss()
    }
}

//MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            tableView.isHidden = true
            timePickerView.isHidden = false
        } else if indexPath.row == 1 {
            let sites = CoreDataManager.shared.sites
            self.goToAnotherViewController(viewController: EnumViewController.source(sites: sites).getViewController()!, typeOfNavigation: .push)
        }
    }
}

//MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsDataManager.tableCellNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as? SettingsTableViewCell else {return UITableViewCell()}
        cell.nameCellLabel.text = settingsDataManager.tableCellNamesArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settingTableView.isHidden = false
        pickerView.isHidden = true
        let customRow = row + 1
        CoreDataManager.shared.addTiming(seconds: Double(customRow * 60))
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        60
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)min"
    }
}
