//
//  NewsDataManager.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 24.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation

class NewsViewModel {
    
    //MARK: - Propertyes
    let newsDataManger = NewsDataManager()
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .default, attributes: [.concurrent], autoreleaseFrequency: .never, target: nil)
    var group = DispatchGroup()
    var item: DispatchWorkItem?
    var isFullNews = true
    var updateCollectionCompletion: () -> Void = {}
    
    //MARK: - Selectors
    @objc private func updateNews(_ notification: Notification){
           updateCollectionCompletion()
       }
    
    //MARK: - Functions
    func waitedForLoadingData(completion: @escaping ()-> Void) {
        self.group.notify(queue: self.concurrentQueue) {
            self.sortingNews()
            completion()
        }
    }
    
    func startParsing() {
        CoreDataManager.shared.sites.forEach({site in
            guard site.isActive else {return}
            self.group.enter()
            self.item = DispatchWorkItem { [weak self] in
                guard let self = self else {return}
                
                self.getNewsAndSaveNewsToBDFromURL(site, completion: {
                    succes in
                    self.group.leave()
                })
            }
            self.concurrentQueue.async(execute: self.item!)
        })
    }
    
    func addObserveUpdateNews() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNews(_:)), name: .update, object: nil)
    }
        
    func checkForHaveThisSite(text: String) -> Bool {
        let stringURLS = CoreDataManager.shared.sites.map {$0.url}
        let isHaveThisSite = stringURLS.contains(text)
        return isHaveThisSite
    }
    
    func addNewRSSURL(text: String, completion: ()-> Void) {
        CoreDataManager.shared.addURL(url: text)
        completion()
    }
    
    func sortingNews() {
        self.newsDataManger.news = CoreDataManager.shared.news
        self.newsDataManger.news = self.newsDataManger.news.filter({$0.siteRelation!.isActive})
        self.newsDataManger.news.sort(by: {$0.date!.timeIntervalSinceNow > $1.date!.timeIntervalSinceNow})
    }
    
    private func getNewsAndSaveNewsToBDFromURL(_ site: Site, completion: @escaping (Bool)-> Void) {
        guard let stringURL = site.url, let url = URL(string: stringURL) else {return}
        NetworkManager.shared.getNews(url: url, completion: { news in
            guard let news = news else { completion(false)
                return }
            let stringURLS = CoreDataManager.shared.news.map {$0.link}
            news.forEach({ news in
                let isHaveThisLink = stringURLS.contains(news.link)
                if !isHaveThisLink {
                    CoreDataManager.shared.addNews(news: news, site: site)
                }
            })
            completion(true)
        })
    }
}
