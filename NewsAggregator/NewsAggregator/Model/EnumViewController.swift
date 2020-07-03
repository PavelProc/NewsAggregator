//
//  ViewController.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 21.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation
import UIKit

enum EnumViewController {
    
    case news
    case targetNews(news: NewsDataBase)
    case settings
    case source(sites: [Site])
    
    func getViewController() -> UIViewController?  {
        switch self {
        case .news:
            let vc = getViewController(storyboardName: "News", identifierViewController: "NewsViewController")
            return vc
        case .targetNews(let news):
            let vc = getViewController(storyboardName: "TargetNews", identifierViewController: "TargetNewsViewController")
            guard let targetVC = vc as? TargetNewsViewController else {return nil}
            targetVC.oneNewsViewModel.news = news
            return vc
        case .settings:
            let vc = getViewController(storyboardName: "Settings", identifierViewController: "SettingsViewController")
            return vc
        case .source(let sites):
            let vc = getViewController(storyboardName: "Source", identifierViewController: "SourceViewController")
            guard let targetVC = vc as? SourceViewController else {return nil}
            targetVC.sites = sites
            return vc
        }
    }
    
    private func getViewController(storyboardName: String, identifierViewController: String) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifierViewController)
        return vc
        
    }
}
