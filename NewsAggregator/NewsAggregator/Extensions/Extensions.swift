//
//  Extensions.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 21.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func present( to: UIViewController, style: UIModalPresentationStyle = .fullScreen) {
        DispatchQueue.main.async { [weak self] () -> Void in
            guard let strongVC = self else { return }
            let navController = UINavigationController(rootViewController: to)
            navController.modalPresentationStyle = style
            strongVC.present(navController, animated: true, completion: nil)
        }
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] () -> Void in
            
            guard let strongVC = self else { return }
            strongVC.dismiss(animated: true, completion: {
                guard let comp = completion else { return }
                comp()
            })
        }
    }
    
    func push(to: UIViewController) {                      DispatchQueue.main.async { [weak self] () -> Void in
        guard let strongVC = self else { return }
        strongVC.navigationController?.pushViewController(to, animated: true)
        }
    }
    func goToAnotherViewController(viewController: UIViewController, typeOfNavigation: TypeOfNavigationBetweenViewControllers, style: UIModalPresentationStyle = .fullScreen) {
        switch typeOfNavigation {
        case .push:
            push(to: viewController )
        case .present:
            present(to: viewController, style: style)
        }
    }
    
    enum TypeOfNavigationBetweenViewControllers {
        case push
        case present
    }
    
    func showAlert(title: String, message: String, placeholder: String? = "", textButton: String = "", withTextField: Bool = false, completion: @escaping (String?)->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if withTextField {
            alert.addTextField { (textField) in
                textField.placeholder = placeholder
            }
        }
        alert.addAction(UIAlertAction(title: textButton, style: .default, handler: { [weak alert] (_) in
            if withTextField{
                guard let textField = alert?.textFields?[0] else {return}
                completion(textField.text)
                print("Text field: \(textField.text)")
            }
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}


extension Notification.Name {
    static let update = Notification.Name("Update")
}
