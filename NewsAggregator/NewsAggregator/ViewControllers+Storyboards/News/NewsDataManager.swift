//
//  NewsDataManager.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 24.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation

class NewsDataManager {
    var news: [NewsDataBase] = []
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .default, attributes: [.concurrent], autoreleaseFrequency: .never, target: nil)
    var group = DispatchGroup()
    var item: DispatchWorkItem?
    var isShortNews = false
}
