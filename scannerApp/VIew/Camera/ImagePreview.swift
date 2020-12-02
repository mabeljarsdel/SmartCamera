//
//  ImagePreview.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import Foundation
import UIKit



class ImagePreview: UIViewController {
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            
            make.width.equalTo(UIScreen.main.bounds.width-20)
            make.height.equalTo(((UIScreen.main.bounds.width-60)/3)*4)
            make.top.equalTo(view.snp.top).offset(10)
            make.centerX.equalTo(view.center.x)
        }
        self.view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}
