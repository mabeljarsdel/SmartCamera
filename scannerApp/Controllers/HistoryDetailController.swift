//
//  HistoryDetailView.swift
//  Translate Camera
//
//  Created by Maksym on 27.12.2020.
//
import Foundation
import UIKit
import CoreData


class HistoryDetailViewController: UIViewController {
    private var model: HistoryModel
    var historyDetailView: HistoryDetailView!
    

    //MARK: Lifecycle
    override func loadView() {
        super.loadView()
        self.historyDetailView = HistoryDetailView()
        self.view = self.historyDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyDetailView.sourceLanguageLabel.text = self.model.fromLanguage!.languageName
        self.historyDetailView.targetLanguageLabel.text = self.model.toLanguage!.languageName
        self.historyDetailView.textView.text = self.model.text
        self.historyDetailView.translatedTextView.text = self.model.translatedText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let contentRect: CGRect = self.historyDetailView.scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        self.historyDetailView.scrollView.contentSize = contentRect.size
        print(self.historyDetailView.scrollView.contentSize)
    }
    
    //MARK: Initializer
    init(cell: HistoryModel) {
        self.model = cell
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
