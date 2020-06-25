//
//  NewsCollectionViewCell.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 19.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var readedNewsView: UIView! {
        didSet {
            readedNewsView.layer.cornerRadius = readedNewsView.frame.height/2
        }
    }
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var descriptionNews: UILabel!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var news: NewsDataBase? {
        didSet {
            
            guard let news = news, let stringImage = news.imageURL, let title = news.title, let description = news.descriptionNews, let from = news.link else {return}
            readedNewsView.isHidden = news.isReaded
            
            if let imageData = news.imageData {
                let image = UIImage(data: imageData)
                self.pictureImageView.image = image
            } else {
                NetworkManager.shared.downloadImage(url: stringImage, completion: { dataImage in
                    guard let dataImage = dataImage,let image = UIImage(data: dataImage) else {return}
                    self.pictureImageView.image = image
                    news.imageData = dataImage
                    CoreDataManager.shared.editNews(news: news)
                })
            }
            fromLabel.text = from
            titleNews.text = title
            descriptionNews.text = description
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImageView.image = nil
    }
}
