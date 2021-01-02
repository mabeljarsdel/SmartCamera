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
    private var model: HistoryModel
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sourceLanguageLabel.text = Locale.current.localizedString(forLanguageCode: self.model.fromLanguage!)
        self.targetLanguageLabel.text = Locale.current.localizedString(forLanguageCode: self.model.toLanguage!)
        self.textView.text = self.model.text
        self.translatedTextView.text = self.model.translatedText
        
        view.backgroundColor = .systemBackground
        self.setupConstaint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
        print(scrollView.contentSize)
    }
    
    //MARK: Initializer
    init(cell: HistoryModel) {
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
            make.width.equalTo(view.frame.width-20)
        }
        
        targetLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom)
            make.height.equalTo(50)
        }
        
        translatedTextView.snp.makeConstraints { make in
            make.top.equalTo(targetLanguageLabel.snp.bottom)
            make.width.equalTo(view.frame.width-20)
        }
        

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
