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
    let viewModel = NewsViewModel()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNewsFromBD()
        updateNews()
        TimerManager.notification = {
            self.updateNews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    //MARK: - IBActions
    @IBAction func typeOfPresentNews(_ sender: UISwitch) {
        viewModel.newsDataManger.isFullNews = sender.isOn
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
                self.viewModel.checkForHaveThisSite(text: text) ? self.showAlert(title: "DearUser", message: "U have this site!", textButton: "OK", completion: { result in}) :
                    self.viewModel.addNewRSSURL(text: text, completion: {
                        self.updateNews()
                    })
                
            } else {
                self.showAlert(title: "DearUser", message: "This in not URL", textButton: "OK", completion: { result in})
            }
        } )
    }
    
    //MARK: - Functions
    private func showNewsFromBD() {
        viewModel.sortingNews()
        collectionView.reloadData()
    }
    
    private func updateNews() {
        self.viewModel.startParsing()
        self.viewModel.waitedForLoadingData(completion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
}


