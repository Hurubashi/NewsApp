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
    
    private let viewModel = NewViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }

    private func initTableView() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        
        viewModel.error.bind(
            onNext: { [weak self] error in
                if let nonNilError = error {
                    self?.showAlert(message: nonNilError.localizedDescription)
                }
            })
            .disposed(by: bag)
        
        viewModel.news
            .bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsCell.self)) {
                row, news, cell in
                cell.initCell(with: news)
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(News.self).subscribe {
            [weak self] newsEvent in
            let vc = NewsDetailVC(nibName: "NewsDetailVC", bundle: nil)
            vc.news = newsEvent.element
            self?.navigationController!.pushViewController(vc , animated: true)
        }
        .disposed(by: bag)
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is NewsDetailVC {
//            let vc = segue.destination as! NewsDetailVC
//            vc =
//        }
//    }
    
}

