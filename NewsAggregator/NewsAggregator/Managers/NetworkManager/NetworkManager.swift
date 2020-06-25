//
//  NetworkManager.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 19.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private init() {}
    static let shared = NetworkManager()
    private let imageCache = NSCache<NSString, NSData>()
    
    func downloadImage(url: String, completion: @escaping (_ image: Data?)->()) {
        guard let url = URL(string: url) else { return }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage as Data)
        } else {
            getData(from: url) { (data, response, error) in
                guard let data = data, error == nil else { return completion(nil)}
                DispatchQueue.main.async {
                    self.imageCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                    completion(data)
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getNews(url: URL, completion: @escaping (_ news: [News]?)->()) {
        let myParser : XmlParserManager = XmlParserManager().initWithURL(url) as! XmlParserManager
        let news = myParser.allFeeds()
        news.count == 0 ? completion(nil) : completion(news)
    }
}
