//
//  ViewController.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 18.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib.init(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
        }
    }
    
    //MARK: - Propertyes
    let newsDataManager = NewsDataManager()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNewsCollectionView()
        startParsing()
        waitedForLoadingData(completion: {
            self.updateNewsCollectionView()
            self.addObserveUpdateNews()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - IBActions
    @IBAction func typeOfPresentNews(_ sender: UISwitch) {
        
        switch sender.isOn {
        case true:
            newsDataManager.isShortNews = false
        case false:
            newsDataManager.isShortNews = true
        }
        collectionView.reloadData()
    }
    
    @IBAction func settingsBarButtonItemAction(_ sender: UIBarButtonItem) {
        self.goToAnotherViewController(viewController: EnumViewController.settings.getViewController()!, typeOfNavigation: .present, style: .fullScreen)
    }
    
    @IBAction func addNewSite(_ sender: UIBarButtonItem) {
        showAlert(title: "Dear User", message: "Enter a URL", placeholder: "http://lenta.ru/rss", textButton: "ADD", withTextField: true, completion: {text in
            guard let text = text else {return}
            let isTextCorrectURL = self.verifyUrl(urlString: text)
            if isTextCorrectURL {
                self.checkForHaveThisSite(text: text) ? self.showAlert(title: "DearUser", message: "U have this site!", textButton: "OK", completion: { result in}) :
                    self.addNewRSSURL(text: text)
                
            } else {
                self.showAlert(title: "DearUser", message: "This in not URL", textButton: "OK", completion: { result in})
            }
        } )
    }
    
    //MARK: - Selectors
    @objc private func updateNews(_ notification: Notification){
        startParsing()
        waitedForLoadingData(completion: {
            self.updateNewsCollectionView()
        })
    }
    
    //MARK: - Functions
    private func addObserveUpdateNews() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNews(_:)), name: .update, object: nil)
    }
    
    private func updateNewsCollectionView() {
        self.newsDataManager.news = CoreDataManager.shared.news
        self.newsDataManager.news = self.newsDataManager.news.filter({$0.siteRelation!.isActive})
        self.newsDataManager.news.sort(by: {$0.date!.timeIntervalSinceNow > $1.date!.timeIntervalSinceNow})
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func waitedForLoadingData(completion: @escaping ()-> Void) {
        newsDataManager.group.notify(queue: newsDataManager.concurrentQueue) {
            completion()
        }
    }
    
    private func checkForHaveThisSite(text: String) -> Bool {
        let stringURLS = CoreDataManager.shared.sites.map {$0.url}
        let isHaveThisSite = stringURLS.contains(text)
        return isHaveThisSite
    }
    
    private func addNewRSSURL(text: String) {
        CoreDataManager.shared.addURL(url: text)
        startParsing()
        waitedForLoadingData(completion: {
            self.updateNewsCollectionView()
        })
    }
    
    private func startParsing() {
        CoreDataManager.shared.sites.forEach({site in
            guard site.isActive else {return}
            newsDataManager.group.enter()
            newsDataManager.item = DispatchWorkItem { [weak self] in
                guard let self = self else {return}
                
                self.getNewsFromURL(site, completion: {
                    succes in
                    self.newsDataManager.group.leave()
                })
            }
            newsDataManager.concurrentQueue.async(execute: newsDataManager.item!)
        })
    }
    
    private func addedNewNews(news: News, site: Site) {
        CoreDataManager.shared.addNews(news: news, site: site)
        
    }
    
    private func getNewsFromURL(_ site: Site, completion: @escaping (Bool)-> Void) {
        guard let stringURL = site.url, let url = URL(string: stringURL) else {return}
        NetworkManager.shared.getNews(url: url, completion: { news in
            guard let news = news else { completion(false)
                return }
            let stringURLS = CoreDataManager.shared.news.map {$0.link}
            news.forEach({ news in
                let isHaveThisLink = stringURLS.contains(news.link)
                if !isHaveThisLink {
                    self.addedNewNews(news: news, site: site)
                }
            })
            completion(true)
        })
    }
}


