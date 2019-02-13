//
//  ViewController.swift
//  NewsApp
//
//  Created by Max Rybak on 2/13/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = NewListViewModel()
    let bag = DisposeBag()
    
    var cache: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        initTableView()
    }
    
    private func initTableView() {
        
        let results = viewModel.news
            .do(
                onNext: { [weak self] news in
                    self?.cache = news
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.showError(error: error)
                    }
            })
            .catchError { error in
                return Observable.empty()
        }
        
        results
            .bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsCell.self)) {
                row, news, cell in
                cell.title.text = news.title
                cell.newsDescription.text = news.description
                DispatchQueue.global().async {
                    if news.urlToImage != nil {
                        if let img = try? Data(contentsOf: news.urlToImage!) {
                            DispatchQueue.main.async {
                                cell.newsImg.image = UIImage(data: img, scale: 0.1)
                            }
                        }
                    }
                }
                
            }
            .disposed(by: bag)
    }
    
    
    
    private func showError(error: Error) {
        if let error = error as? NewsService.ApiError {
            switch error {
            case .wentWrong : showAlert(message: "Something went wrong")
            }
        } else {
            showAlert(message: "Error occurred")
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
}

