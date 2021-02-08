//
//  SubscriptionViewController.swift
//  Translate Camera
//
//  Created by Maksym on 07.02.2021.
//

import Foundation
import UIKit


class SubscriptionViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        let subscriptionView = SubscriptionView()
        subscriptionView.closeButton.addTarget(self, action: #selector(dismissView), for: .touchDown)
        self.view = subscriptionView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}



