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
    var textView: UITextView!
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
        
        self.textView = UITextView()
        self.textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        
        
        textView.snp.makeConstraints { make in
            make.width.height.equalTo(UIScreen.main.bounds.width-20)
            make.topMargin.equalTo(imageView.snp.bottomMargin)
            make.centerX.equalTo(view.center.x)
        
        }
        
    
        
        self.view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let processor = ScaledElementProcessor()
        self.textView.text = ""
        if self.imageView != nil {
            processor.process(in: self.imageView, callback: { text in
                guard let textResult = text else { return }
                self.textView!.text += textResult.text
                for block in textResult.blocks {
                    print(block.frame)
                }
            })
        }
        
        
    }
}
