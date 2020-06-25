//
//  ExtensionNewsCollectionView.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 24.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation
import UIKit

//MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let targetNews = newsDataManager.news[indexPath.row]
        guard let targetViewController = EnumViewController.targetNews(news: targetNews).getViewController() else {return}
        self.goToAnotherViewController(viewController: targetViewController, typeOfNavigation: .push)
    }
}

//MARK: - UICollectionViewDataSource
extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsDataManager.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else { return UICollectionViewCell() }
        cell.descriptionNews.isHidden = newsDataManager.isShortNews
        cell.news = newsDataManager.news[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension NewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
