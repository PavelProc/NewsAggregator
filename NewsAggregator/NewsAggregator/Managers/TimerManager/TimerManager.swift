//
//  TimerManager.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 23.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation

class TimerManager {
    
    static var notification: () -> Void = {}

    static func changeTimerValue(time: Double) {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(TimerManager.updateNews), userInfo: nil, repeats: true)
    }
    
    @objc static func updateNews() {
        notification()
    }
}
