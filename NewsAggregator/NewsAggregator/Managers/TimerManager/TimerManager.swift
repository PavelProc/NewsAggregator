//
//  TimerManager.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 23.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation

class TimerManager {
    private init() {}
    static let shared = TimerManager()
    
    var timer = Timer()
    
    func changeTimerValue(time: Double) {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.updateNews), userInfo: nil, repeats: true)
    }
    @objc func updateNews() {
        NotificationCenter.default.post(name: .update, object: nil)
    }
}
