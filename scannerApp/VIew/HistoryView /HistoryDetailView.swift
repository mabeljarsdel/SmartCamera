//
//  HistoryDetailView.swift
//  Translate Camera
//
//  Created by Maksym on 27.12.2020.
//

import Foundation
import UIKit
import CoreData

class HistoryDetailView: UIViewController {
    let sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.text = "test1"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.text = "test2"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        tv.text = "textView"
        return tv
    }()
    
    let translatedTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        tv.text = "translatedTextView"
        
        return tv
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false

        return sv
    }()

    
    //Cell model
    private var model: NSManagedObject
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sourceLanguageLabel.text = self.model.value(forKeyPath: HistoryModelConstant.fromLanguage) as? String
        self.targetLanguageLabel.text = self.model.value(forKeyPath: HistoryModelConstant.toLanguage) as? String
        self.textView.text = self.model.value(forKeyPath: HistoryModelConstant.text) as? String
        self.translatedTextView.text = self.model.value(forKeyPath: HistoryModelConstant.translatedText) as? String
        
        view.backgroundColor = .systemBackground
//        self.scrollView.backgroundColor = .systemBackground
        
        self.setupConstaint()
    }
    
    //MARK: Initializer
    init(cell: NSManagedObject) {
        self.model = cell
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup view
    func setupConstaint() {
        view.addSubview(scrollView)

        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
        }
        
        
        scrollView.addSubview(textView)
        scrollView.addSubview(translatedTextView)
        scrollView.addSubview(sourceLanguageLabel)
        scrollView.addSubview(targetLanguageLabel)
        
   
        
        sourceLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.height.equalTo(50)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(sourceLanguageLabel.snp.bottom)
            make.width.equalTo(view.frame.width)
        }
        
        targetLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom)
            make.height.equalTo(50)
        }
        
        translatedTextView.snp.makeConstraints { make in
            make.top.equalTo(targetLanguageLabel.snp.bottom)
            make.width.equalTo(view.frame.width)
        }
        
        scrollView.contentSize.height = sourceLanguageLabel.intrinsicContentSize.height + textView.intrinsicContentSize.height + targetLanguageLabel.intrinsicContentSize.height + translatedTextView.intrinsicContentSize.height + 20
        
        print(scrollView.contentSize.height)
    }
}



extension UIScrollView {

    func resizeScrollViewContentSize() {

        var contentRect = CGRect.zero

        for view in self.subviews {

            contentRect = contentRect.union(view.frame)

        }

        self.contentSize = contentRect.size

    }
}
