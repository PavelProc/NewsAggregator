//
//  CustomLaunchScreenViewModel.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 02.07.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation

class CustomLaunchScreenViewModel {
    
    //MARK: - Propertyes
    let dataManager = CustomLaunchDataManager()
    
    //MARK: - Functions
    func config() {
        if CoreDataManager.shared.timings.count == 0 {
            CoreDataManager.shared.addTiming(seconds: dataManager.defaultTimerValueSeconds)
            TimerManager.changeTimerValue(time: dataManager.defaultTimerValueSeconds)
        } else {
            guard let seconds = CoreDataManager.shared.timings.last?.seconds else {return}
            TimerManager.changeTimerValue(time: seconds)
        }
        
        dataManager.defaultParseStringURL.forEach({ stringURL in
            let dataBaseStringURLS = CoreDataManager.shared.sites.map {$0.url}
            let result = dataBaseStringURLS.contains(stringURL)
            result ? nil : CoreDataManager.shared.addURL(url: stringURL)
        })
    }
}
