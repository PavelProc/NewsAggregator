//
//  CustomLaunchScreenViewController.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 21.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import UIKit

class CustomLaunchScreenViewController: UIViewController {
    
    //MARK: - Propertyes
    let customLaunchScreenViewModel = CustomLaunchScreenViewModel()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customLaunchScreenViewModel.config()
        self.goToAnotherViewController(viewController: EnumViewController.news.getViewController()!, typeOfNavigation: .present, style: .fullScreen)
    }
}



