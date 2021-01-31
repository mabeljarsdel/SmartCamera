//
//  HistoryDetailView.swift
//  Translate Camera
//
//  Created by Maksym on 09.01.2021.
//

import Foundation
import UIKit


class HistoryDetailView: UIView {
    let sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let translatedTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupConstaint()
        self.backgroundColor = .systemBackground
        self.textView.font = self.textView.font?.withSize(20)
        self.translatedTextView.font = self.textView.font
    }
    
    
    func setupConstaint() {
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
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
            make.width.equalTo(self.frame.width-20)
        }
        
        targetLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom)
            make.height.equalTo(50)
        }
        
        translatedTextView.snp.makeConstraints { make in
            make.top.equalTo(targetLanguageLabel.snp.bottom)
            make.width.equalTo(self.frame.width-20)
        }
    }
}
 
