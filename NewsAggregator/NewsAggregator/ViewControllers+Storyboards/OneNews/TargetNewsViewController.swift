//
//  TargetNewsViewController.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 22.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import UIKit

class TargetNewsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var descriptionNewsLabel: UILabel!
    @IBOutlet weak var titleNewsLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    //MARK: - Propertyes
    var news: NewsDataBase!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        changeTargetNewsIsReaded()
    }
    
    //MARK: - Functions
    private func changeTargetNewsIsReaded() {
        news.isReaded = true
        CoreDataManager.shared.editNews(news: news)
    }
    
    private func settingUI() {
        guard let stringImageURL = news.imageURL, let titleNews = news.title, let descriptionNews = news.descriptionNews, let fromNews = news.link else {return}
        
        if let imageData = news.imageData {
            let image = UIImage(data: imageData)
            self.newsImageView.image = image
        } else {
            NetworkManager.shared.downloadImage(url: stringImageURL, completion: { dataImage in
                guard let dataImage = dataImage,let image = UIImage(data: dataImage) else {return}
                self.newsImageView.image = image
            })
        }
        
        descriptionNewsLabel.text = descriptionNews
        titleNewsLabel.text = titleNews
        fromLabel.text = fromNews
    }
}
