//
//  CustomLaunchScreenViewController.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 21.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import UIKit

class CustomLaunchScreenViewController: UIViewController {
    
    //MARK: - Propertyes
    let dataManager = CustomLaunchDataManager()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        self.goToAnotherViewController(viewController: EnumViewController.news.getViewController()!, typeOfNavigation: .present, style: .fullScreen)
    }
    
    //MARK: - Functions
    private func config() {
        if CoreDataManager.shared.timings.count == 0 {
            CoreDataManager.shared.addTiming(seconds: dataManager.defaultTimerValueSeconds)
            TimerManager.shared.changeTimerValue(time: dataManager.defaultTimerValueSeconds)
        } else {
            guard let seconds = CoreDataManager.shared.timings.last?.seconds else {return}
            TimerManager.shared.changeTimerValue(time: seconds)
            
        }
        
        dataManager.defaultParseStringURL.forEach({ stringURL in
            let dataBaseStringURLS = CoreDataManager.shared.sites.map {$0.url}
            let result = dataBaseStringURLS.contains(stringURL)
            result ? nil : CoreDataManager.shared.addURL(url: stringURL)
        })        
    }
}



