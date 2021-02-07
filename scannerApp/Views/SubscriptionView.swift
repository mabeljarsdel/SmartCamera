//
//  SubscriptionView.swift
//  Translate Camera
//
//  Created by Maksym on 07.02.2021.
//

import Foundation
import UIKit


class SubscriptionView: UIView {
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel", for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(closeButton)
        self.backgroundColor = .systemBackground
    }
}
